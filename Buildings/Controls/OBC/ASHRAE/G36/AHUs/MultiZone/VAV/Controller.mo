within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV;
block Controller "Multizone VAV air handling unit controller"

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns minOADes
    "Design of minimum outdoor air and economizer function"
    annotation (Dialog(group="Economizer design"));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
    "Type of building pressure control system"
    annotation (Dialog(group="Economizer design"));
  parameter Real aveTimRan(unit="s")=5
    "Time horizon over which the outdoor air flow measurment is averaged"
    annotation (Dialog(group="Economizer design"));
  parameter Integer nZonGro=1
    "Total number of zone group that the AHU is serving"
    annotation (Dialog(group="System and building parameters"));
  parameter Integer nRelFan=1
    "Total number of relief fans that are serving a common space"
    annotation (Dialog(group="System and building parameters",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan));
  parameter Integer nAHU=1
    "Total number of AHU that are serving a common space"
    annotation (Dialog(group="System and building parameters",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan));
  parameter Boolean have_heaCoi=true
    "True: the AHU has heating coil"
    annotation (Dialog(group="System and building parameters"));
  parameter Boolean have_perZonRehBox=false
    "Check if there is any VAV-reheat boxes on perimeter zones"
    annotation (Dialog(group="System and building parameters"));
  parameter Boolean have_duaDucBox=false
    "Check if the AHU serves dual duct boxes"
    annotation (Dialog(group="System and building parameters"));
  parameter Boolean have_airFloMeaSta=false
    "Check if the AHU has AFMS (Airflow measurement station)"
    annotation (Dialog(group="System and building parameters"));
  parameter Boolean have_freSta=false
    "True: the system has a physical freeze stat"
    annotation (Dialog(group="System and building parameters"));
  parameter Real VPriSysMax_flow(unit="m3/s")
    "Maximum expected system primary airflow at design stage"
    annotation (Dialog(group="Minimum outdoor air setpoint"));
  parameter Real peaSysPop "Peak system population"
    annotation (Dialog(group="Minimum outdoor air setpoint"));

  // ----------- parameters for fan speed control  -----------
  parameter Real pIniSet(
    unit="Pa",
    displayUnit="Pa")=120
    "Initial pressure setpoint for fan speed control"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pMinSet(
    unit="Pa",
    displayUnit="Pa")=25
    "Minimum pressure setpoint for fan speed control"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pMaxSet(unit="Pa", displayUnit="Pa")
    "Maximum pressure setpoint for supply fan speed control"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pDelTim(unit="s")=600
    "Delay time after which trim and respond is activated"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pSamplePeriod(unit="s")=120
    "Sample period"
    annotation (Dialog(tab="Fan speed",group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Integer pNumIgnReq=2
    "Number of ignored requests"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pTriAmo(
    unit="Pa",
    displayUnit="Pa")=-12.0
    "Trim amount"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pResAmo(
    unit="Pa",
    displayUnit="Pa")=15
    "Respond amount (must be opposite in to trim amount)"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Real pMaxRes(
    unit="Pa",
    displayUnit="Pa")=32
    "Maximum response per time interval (same sign as respond amount)"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController fanSpeCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Supply fan speed PID controller"
    annotation (Dialog(tab="Fan speed", group="PID controller"));
  parameter Real kFanSpe(unit="1")=0.1
    "Gain of supply fan speed PID controller"
    annotation (Dialog(tab="Fan speed", group="PID controller"));
  parameter Real TiFanSpe(unit="s")=60
    "Time constant of integrator block for supply fan speed PID controller"
    annotation (Dialog(tab="Fan speed", group="PID controller",
      enable=fanSpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or fanSpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdFanSpe(unit="s")=0.1
    "Time constant of derivative block for supply fan speed PID controller"
    annotation (Dialog(tab="Fan speed", group="PID controller",
      enable=fanSpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or fanSpeCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yFanMax=1
    "Maximum allowed fan speed"
    annotation (Dialog(tab="Fan speed", group="PID controller"));
  parameter Real yFanMin=0.1
    "Lowest allowed fan speed if fan is on"
    annotation (Dialog(tab="Fan speed", group="PID controller"));

  // ----------- parameters for supply air temperature control  -----------
  parameter Real TSupCooMin(
    unit="K",
    displayUnit="degC")=285.15
    "Lowest cooling supply air temperature setpoint when the outdoor air temperature is at the higher value of the reset range and above"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real TSupCooMax(
    unit="K",
    displayUnit="degC")=291.15
    "Highest cooling supply air temperature setpoint. It is typically 18 degC (65 degF) 
    in mild and dry climates, 16 degC (60 degF) or lower in humid climates"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real TOutMin(
    unit="K",
    displayUnit="degC")=289.15
    "Lower value of the outdoor air temperature reset range. Typically value is 16 degC (60 degF)"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real TOutMax(
    unit="K",
    displayUnit="degC")=294.15
    "Higher value of the outdoor air temperature reset range. Typically value is 21 degC (70 degF)"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real TSupWarUpSetBac(
    unit="K",
    displayUnit="degC")=308.15
    "Supply temperature in warm up and set back mode"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));
  parameter Real delTimSupTem(unit="s")=600
    "Delay timer"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Real samPerSupTem(unit="s")=120
    "Sample period of component"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Integer ignReqSupTem=2
    "Number of ignorable requests for TrimResponse logic"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Real triAmoSupTem(
    unit="K",
    displayUnit="K")=0.1
    "Trim amount"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Real resAmoSupTem(
    unit="K",
    displayUnit="K")=-0.2
    "Response amount"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));
  parameter Real maxResSupTem(
    unit="K",
    displayUnit="K")=-0.6
    "Maximum response per time interval"
    annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting supply air temperature setpoint"));

  // ----------- parameters for heating and cooling coil control  -----------
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController valCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for coil valves control"
    annotation (Dialog(tab="Coils", group="Valves PID controller"));
  parameter Real kVal(unit="1")=0.05
    "Gain of controller for valve control"
    annotation (Dialog(tab="Coils", group="Valves PID controller"));
  parameter Real TiVal(unit="s")=600
    "Time constant of integrator block for valve control"
    annotation (Dialog(tab="Coils", group="Valves PID controller",
      enable=valCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or valCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdVal(unit="s")=0.1
    "Time constant of derivative block for valve control"
    annotation (Dialog(tab="Coils", group="Valves PID controller",
      enable=valCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or valCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real uHeaCoiMax=-0.25
    "Upper limit of controller signal when heating coil is off. Require -1 < uHeaMax < uCooMin < 1."
    annotation (Dialog(tab="Coils", group="Limits"));
  parameter Real uCooCoiMin=0.25
    "Lower limit of controller signal when cooling coil is off. Require -1 < uHeaMax < uCooMin < 1."
    annotation (Dialog(tab="Coils", group="Limits"));

  // ----------- parameters for economizer control  -----------
  // Limits
  parameter Real minSpe(unit="1")
    "Minimum supply fan speed"
    annotation (Dialog(tab="Economizer",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
             or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController minOAConTyp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Type of minimum outdoor air controller"
    annotation (Dialog(tab="Economizer", group="Limits, separated with AFMS",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
             or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper));
  parameter Real kMinOA(unit="1")=1
    "Gain of controller"
    annotation (Dialog(tab="Economizer", group="Limits, separated with AFMS",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
             or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper));
  parameter Real TiMinOA(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Economizer", group="Limits, separated with AFMS",
      enable=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
              or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper)
        and (minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
             or minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdMinOA(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Economizer", group="Limits, separated with AFMS",
      enable=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
              or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper)
        and (minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
             or minOAConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real dpDesOutDam_min(unit="Pa")
    "Design pressure difference across the minimum outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController dpConTyp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of differential pressure setpoint controller"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP));
  parameter Real kDp(unit="1")=1
    "Gain of controller"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP));
  parameter Real TiDp(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
              or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper)
        and (dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDp(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Economizer", group="Limits, separated with DP",
      enable=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
              or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper)
        and (dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or dpConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real uMinRetDam(unit="1")=0.5
    "Loop signal value to start decreasing the maximum return air damper position"
    annotation (Dialog(tab="Economizer", group="Limits, Common",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper));
  // Enable
  parameter Boolean use_enthalpy=true
    "Set to true to evaluate outdoor air enthalpy in addition to temperature"
    annotation (Dialog(tab="Economizer", group="Enable"));
  parameter Real delTOutHis(
    unit="K",
    displayUnit="K")=1
    "Delta between the temperature hysteresis high and low limit"
    annotation (Dialog(tab="Economizer", group="Enable"));
  parameter Real delEntHis(unit="J/kg")=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation (Dialog(tab="Economizer", group="Enable"));
  parameter Real retDamFulOpeTim(unit="s")=180
    "Time period to keep return air damper fully open before releasing it for minimum outdoor airflow control
    at disable to avoid pressure fluctuations"
    annotation (Dialog(tab="Economizer", group="Enable"));
  parameter Real disDel(unit="s")=15
    "Short time delay before closing the outdoor air damper at disable to avoid pressure fluctuations"
    annotation (Dialog(tab="Economizer", group="Enable"));
  // Modulation
  parameter Real samplePeriod(unit="s")=300
    "Sample period of component, used to limit the rate of change of the dampers (to avoid quick opening that can result in frost)"
    annotation (Dialog(tab="Economizer", group="Modulation"));
  // Commissioning
  parameter Real retDamPhyPosMax(unit="1")=1
    "Physically fixed maximum position of the return air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits"));
  parameter Real retDamPhyPosMin(unit="1")=0
    "Physically fixed minimum position of the return air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits"));
  parameter Real outDamPhyPosMax(unit="1")=1
    "Physically fixed maximum position of the outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits"));
  parameter Real outDamPhyPosMin(unit="1")=0
    "Physically fixed minimum position of the outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits"));
  parameter Real minOutDamPhyPosMax(unit="1")=1
    "Physically fixed maximum position of the minimum outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS));
  parameter Real minOutDamPhyPosMin(unit="1")=0
    "Physically fixed minimum position of the minimum outdoor air damper"
    annotation (Dialog(tab="Economizer", group="Commissioning, limits",
      enable=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS));
  parameter Real uHeaMax(unit="1")=-0.25
    "Lower limit of controller input when outdoor damper opens (see diagram)"
    annotation (Dialog(tab="Economizer", group="Commissioning, modulation"));
  parameter Real uCooMin(unit="1")=+0.25
    "Upper limit of controller input when return damper is closed (see diagram)"
    annotation (Dialog(tab="Economizer", group="Commissioning, modulation"));
  parameter Real uOutDamMax(unit="1")=(uHeaMax + uCooMin)/2
    "Maximum loop signal for the OA damper to be fully open"
    annotation (Dialog(tab="Economizer", group="Commissioning, modulation",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
             or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan));
  parameter Real uRetDamMin(unit="1")=(uHeaMax + uCooMin)/2
    "Minimum loop signal for the RA damper to be fully open"
    annotation (Dialog(tab="Economizer", group="Commissioning, modulation",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
             or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan));

  // ----------- parameters for freeze protection -----------
  parameter Integer minHotWatReq=2
    "Minimum heating hot-water plant request to active the heating plant"
    annotation (Dialog(tab="Freeze protection"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController freProHeaCoiCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Freeze protection heating coil controller"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller"));
  parameter Real kFrePro(unit="1")=1
    "Gain of coil controller"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller"));
  parameter Real TiFrePro(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller",
      enable=freProHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or freProHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TdFrePro(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller",
      enable=freProHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or freProHeaCoiCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yMaxFrePro=1
    "Upper limit of output"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller"));
  parameter Real yMinFrePro=0
    "Lower limit of output"
    annotation (Dialog(tab="Freeze protection", group="Heating coil PID Controller"));

  // ----------- Building pressure control parameters -----------
  parameter Real dpBuiSet(
    unit="Pa",
    displayUnit="Pa")=12
    "Building static pressure difference relative to ambient (positive to pressurize the building)"
    annotation (Dialog(tab="Pressure control",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
             or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
             or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));
  parameter Real kRelDam(unit="1")=0.5
    "Gain, applied to building pressure control error normalized with dpBuiSet"
    annotation (Dialog(tab="Pressure control", group="Relief damper",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper));
  parameter Real kRelFan(unit="1")=1
    "Gain, normalized using dpBuiSet"
    annotation (Dialog(tab="Pressure control", group="Relief fans",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan));
  parameter Real minSpeRelFan(unit="1")
    "Minimum relief fan speed"
    annotation (Dialog(tab="Pressure control", group="Relief fans",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan));
  parameter Integer staVec[nRelFan]={2,3,1,4}
    "Vector of the order for staging up relief fan, i.e. the 1st element means the 1st relief fan and its value showing its sequence when staging up"
    annotation (Dialog(tab="Pressure control", group="Relief fans",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan));
  parameter Integer RelFanMat[nRelFan,nSupFan]={{1,0},{1,0},{0,1},{0,1}}
    "Relief fan matrix with relief fan as row index and AHU supply fan as column index. It falgs which relief fan is associated with which supply fan"
    annotation (Dialog(tab="Pressure control", group="Relief fans",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan));
  parameter Real difFloSet(unit="m3/s")
    "Airflow differential between supply air and return air fans required to maintain building pressure at desired pressure"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController retFanCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PID
    "Type of controller for return fan"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
             or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));
  parameter Real kRetFan(unit="1")=1
                      "Gain, normalized using dpBuiSet"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
             or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));
  parameter Real TiRetFan(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
              or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
         and (retFanCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
              or retFanCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdRetFan(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
              or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
         and (retFanCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
              or retFanCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real dpDisMin(
    unit="Pa",
    displayUnit="Pa")=2.4
    "Minimum return fan discharge static pressure difference setpoint"
    annotation (Dialog(tab="Pressure control", group="Return fan",
      enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));
  parameter Real dpDisMax(
    unit="Pa",
    displayUnit="Pa")=40
    "Maximum return fan discharge static pressure setpoint"
    annotation (Dialog(tab="Pressure control", group="Return fan",
        enable=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp));

  // ----------- Advanced parameters -----------
  parameter Real Thys=0.25 "Hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));
  parameter Real posHys=0.05
    "Hysteresis for checking valve position difference"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod[nZonGro]
    "Zone group operation mode"
    annotation (Placement(transformation(extent={{-400,550},{-360,590}}),
        iconTransformation(extent={{-240,410},{-200,450}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{-400,510},{-360,550}}),
        iconTransformation(extent={{-240,390},{-200,430}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ducStaPre(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    "Measured duct static pressure"
    annotation (Placement(transformation(extent={{-400,470},{-360,510}}),
        iconTransformation(extent={{-240,360},{-200,400}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-400,440},{-360,480}}),
        iconTransformation(extent={{-240,340},{-200,380}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonTemResReq
    "Zone cooling supply air temperature reset request"
    annotation (Placement(transformation(extent={{-400,410},{-360,450}}),
        iconTransformation(extent={{-240,310},{-200,350}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-400,370},{-360,410}}),
        iconTransformation(extent={{-240,290},{-200,330}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-400,330},{-360,370}}),
        iconTransformation(extent={{-240,260},{-200,300}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput sumDesZonPop(
    final min=0,
    final unit="1")
    "Sum of the design population of the zones in the group"
    annotation (Placement(transformation(extent={{-400,280},{-360,320}}),
        iconTransformation(extent={{-240,230},{-200,270}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumDesPopBreZon_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the population component design breathing zone flow rate"
    annotation (Placement(transformation(extent={{-400,250},{-360,290}}),
        iconTransformation(extent={{-240,190},{-200,230}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumDesAreBreZon_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of the area component design breathing zone flow rate"
    annotation (Placement(transformation(extent={{-400,220},{-360,260}}),
        iconTransformation(extent={{-240,170},{-200,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDesSysVenEff(
    final min=0,
    final unit="1")
    "Design system ventilation efficiency, equals to the minimum of all zones ventilation efficiency"
    annotation (Placement(transformation(extent={{-400,190},{-360,230}}),
        iconTransformation(extent={{-240,140},{-200,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumUncOutAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Sum of all zones required uncorrected outdoor airflow rate"
    annotation (Placement(transformation(extent={{-400,160},{-360,200}}),
        iconTransformation(extent={{-240,110},{-200,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumSysPriAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "System primary airflow rate, equals to the sum of the measured discharged flow rate of all terminal units"
    annotation (Placement(transformation(extent={{-400,130},{-360,170}}),
        iconTransformation(extent={{-240,90},{-200,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutAirFra_max(
    final min=0,
    final unit="1")
    "Maximum zone outdoor air fraction, equals to the maximum of primary outdoor air fraction of all zones"
    annotation (Placement(transformation(extent={{-400,100},{-360,140}}),
        iconTransformation(extent={{-240,60},{-200,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VOut_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    if (minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
        or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper)
    "Measured outdoor volumetric airflow rate"
    annotation (Placement(transformation(extent={{-400,70},{-360,110}}),
        iconTransformation(extent={{-240,30},{-200,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    if (minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
        or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP)
    "Economizer outdoor air damper position"
    annotation (Placement(transformation(extent={{-400,30},{-360,70}}),
        iconTransformation(extent={{-240,0},{-200,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    if (minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
        or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP)
    "Supply fan speed"
    annotation (Placement(transformation(extent={{-400,0},{-360,40}}),
        iconTransformation(extent={{-240,-30},{-200,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpMinOutDam(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    if minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP
    "Measured pressure difference across the minimum outdoor air damper"
    annotation (Placement(transformation(extent={{-400,-30},{-360,10}}),
        iconTransformation(extent={{-240,-60},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutCut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-400,-60},{-360,-20}}),
        iconTransformation(extent={{-240,-100},{-200,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-400,-90},{-360,-50}}),
        iconTransformation(extent={{-240,-120},{-200,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOutCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-400,-120},{-360,-80}}),
        iconTransformation(extent={{-240,-140},{-200,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFreSta if have_freSta
    "Freeze-stat signal"
    annotation (Placement(transformation(extent={{-400,-160},{-360,-120}}),
        iconTransformation(extent={{-240,-180},{-200,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uFreStaRes if have_freSta
    "Freeze protection stat reset signal"
    annotation (Placement(transformation(extent={{-400,-200},{-360,-160}}),
        iconTransformation(extent={{-240,-200},{-200,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSofSwiRes if not have_freSta
    "Freeze protection reset signal from software switch"
    annotation (Placement(transformation(extent={{-400,-230},{-360,-190}}),
        iconTransformation(extent={{-240,-220},{-200,-180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRetFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan speed"
    annotation (Placement(transformation(extent={{-400,-260},{-360,-220}}),
        iconTransformation(extent={{-240,-250},{-200,-210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uRelFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan speed"
    annotation (Placement(transformation(extent={{-400,-290},{-360,-250}}),
        iconTransformation(extent={{-240,-270},{-200,-230}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured mixed air temperature"
    annotation (Placement(transformation(extent={{-400,-320},{-360,-280}}),
        iconTransformation(extent={{-240,-300},{-200,-260}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpBui(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{-400,-354},{-360,-314}}),
        iconTransformation(extent={{-240,-330},{-200,-290}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFanSet[nAHU]
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Supply fan proven on status for AHUs that serving a common space"
    annotation (Placement(transformation(extent={{-400,-390},{-360,-350}}),
        iconTransformation(extent={{-240,-350},{-200,-310}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRelFan[nRelFan]
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Proven on status of the relief fans that serving a common space"
    annotation (Placement(transformation(extent={{-400,-420},{-360,-380}}),
        iconTransformation(extent={{-240,-370},{-200,-330}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSup_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
    "Measured AHU supply airflow rate"
    annotation (Placement(transformation(extent={{-400,-450},{-360,-410}}),
        iconTransformation(extent={{-240,-390},{-200,-350}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VRet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
    "Measured AHU return airflow rate"
    annotation (Placement(transformation(extent={{-400,-490},{-360,-450}}),
        iconTransformation(extent={{-240,-410},{-200,-370}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling coil valve position"
    annotation (Placement(transformation(extent={{-400,-530},{-360,-490}}),
        iconTransformation(extent={{-240,-430},{-200,-390}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_heaCoi
    "Heating coil valve position"
    annotation (Placement(transformation(extent={{-400,-580},{-360,-540}}),
        iconTransformation(extent={{-240,-450},{-200,-410}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySupFan
    "Supply fan enabling status"
    annotation (Placement(transformation(extent={{360,530},{400,570}}),
        iconTransformation(extent={{200,360},{240,400}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDesUncOutAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Design uncorrected minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{360,310},{400,350}}),
        iconTransformation(extent={{200,270},{240,310}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAveOutAirFraPlu
    "Average outdoor air flow fraction plus 1"
    annotation (Placement(transformation(extent={{360,280},{400,320}}),
        iconTransformation(extent={{200,240},{240,280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VEffOutAir_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Effective minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{360,240},{400,280}}),
      iconTransformation(extent={{200,210},{240,250}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yReqOutAir
    "True if the AHU supply fan is on and the zone is in occupied mode"
    annotation (Placement(transformation(extent={{360,200},{400,240}}),
        iconTransformation(extent={{200,180},{240,220}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMinOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    if not minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper
    "Outdoor air damper position to ensure minimum outdoor air flow"
    annotation (Placement(transformation(extent={{360,110},{400,150}}),
        iconTransformation(extent={{200,140},{240,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Return air damper position"
    annotation (Placement(transformation(extent={{360,70},{400,110}}),
        iconTransformation(extent={{200,110},{240,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelDamPos(
    final min=0,
    final max=1,
    final unit="1")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir)
    "Relief air damper position"
    annotation (Placement(transformation(extent={{360,30},{400,70}}),
        iconTransformation(extent={{200,80},{240,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{360,-10},{400,30}}),
        iconTransformation(extent={{200,50},{240,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEneCHWPum
    "Energize chilled water pump"
    annotation (Placement(transformation(extent={{360,-70},{400,-30}}),
        iconTransformation(extent={{200,0},{240,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Supply fan speed setpoint"
    annotation (Placement(transformation(extent={{360,-110},{400,-70}}),
        iconTransformation(extent={{200,-42},{240,-2}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Return fan speed setpoint"
    annotation (Placement(transformation(extent={{360,-140},{400,-100}}),
        iconTransformation(extent={{200,-70},{240,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelFanSpe(
    final min=0,
    final max=1,
    final unit="1")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan speed setpoint"
    annotation (Placement(transformation(extent={{360,-170},{400,-130}}),
        iconTransformation(extent={{200,-100},{240,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling coil valve position"
    annotation (Placement(transformation(extent={{360,-230},{400,-190}}),
        iconTransformation(extent={{200,-140},{240,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final min=0,
    final max=1,
    final unit="1") if have_heaCoi
    "Heating coil valve position"
    annotation (Placement(transformation(extent={{360,-260},{400,-220}}),
        iconTransformation(extent={{200,-170},{240,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDpBui(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "Building static pressure difference, relative to ambient (positive if pressurized)"
    annotation (Placement(transformation(extent={{360,-300},{400,-260}}),
        iconTransformation(extent={{200,-210},{240,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelFanSpeSet[nRelFan](
    final min=fill(0, nRelFan),
    final max=fill(1, nRelFan),
    final unit=fill("1", nRelFan))
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Relief fan speed setpoint"
    annotation (Placement(transformation(extent={{360,-330},{400,-290}}),
        iconTransformation(extent={{200,-230},{240,-190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam[nRelFan](
    final min=fill(0, nRelFan),
    final max=fill(1, nRelFan),
    final unit=fill("1", nRelFan))
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "Damper position setpoint for the relief fans"
    annotation (Placement(transformation(extent={{360,-370},{400,-330}}),
        iconTransformation(extent={{200,-250},{240,-210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yExhDam(
    final min=0,
    final max=1,
    final unit="1")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp
    "Exhaust damper control signal (0: closed, 1: open)"
    annotation (Placement(transformation(extent={{360,-400},{400,-360}}),
        iconTransformation(extent={{200,-270},{240,-230}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dpDisSet(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="PressureDifference")
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp
    "Return fan discharge static pressure setpoint"
    annotation (Placement(transformation(extent={{360,-430},{400,-390}}),
        iconTransformation(extent={{200,-290},{240,-250}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiWatResReq
    "Chilled water reset request"
    annotation (Placement(transformation(extent={{360,-480},{400,-440}}),
        iconTransformation(extent={{200,-330},{240,-290}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiPlaReq
    "Chiller plant request"
    annotation (Placement(transformation(extent={{360,-510},{400,-470}}),
        iconTransformation(extent={{200,-370},{240,-330}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatResReq if have_heaCoi
    "Hot water reset request"
    annotation (Placement(transformation(extent={{360,-560},{400,-520}}),
        iconTransformation(extent={{200,-410},{240,-370}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yHotWatPlaReq if have_heaCoi
    "Hot water plant request"
    annotation (Placement(transformation(extent={{360,-590},{400,-550}}),
        iconTransformation(extent={{200,-450},{240,-410}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold freProMod
    "Check if it is in freeze protection mode"
    annotation (Placement(transformation(extent={{180,-570},{200,-550}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi if have_heaCoi
    "Hot water plant request"
    annotation (Placement(transformation(extent={{300,-580},{320,-560}})));
  Buildings.Controls.OBC.CDL.Continuous.Division VOut_flow_normalized(
    u1(final unit="m3/s"),
    u2(final unit="m3/s"),
    y(final unit="1"))
    if (minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
        or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper)
    "Normalization of outdoor air flow intake by design minimum outdoor air intake"
    annotation (Placement(transformation(extent={{0,74},{20,94}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.FreezeProtection frePro(
    final buiPreCon=buiPreCon,
    final minOADes=minOADes,
    final have_heaCoi=have_heaCoi,
    final have_freSta=have_freSta,
    final minHotWatReq=minHotWatReq,
    final heaCoiCon=freProHeaCoiCon,
    final k=kFrePro,
    final Ti=TiFrePro,
    final Td=TdFrePro,
    final yMax=yMaxFrePro,
    final yMin=yMinFrePro,
    final Thys=Thys)
    "Freeze protection"
    annotation (Placement(transformation(extent={{200,-210},{220,-170}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests plaReq(
    final have_heaCoi=have_heaCoi,
    final Thys=Thys,
    final posHys=posHys)
    "Plant requests"
    annotation (Placement(transformation(extent={{-20,-540},{0,-520}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Controller ecoCon(
    final minOADes=minOADes,
    final buiPreCon=buiPreCon,
    final aveTimRan=aveTimRan,
    final minSpe=minSpe,
    final minOAConTyp=minOAConTyp,
    final kMinOA=kMinOA,
    final TiMinOA=TiMinOA,
    final TdMinOA=TdMinOA,
    final dpDesOutDam_min=dpDesOutDam_min,
    final dpConTyp=dpConTyp,
    final kDp=kDp,
    final TiDp=TiDp,
    final TdDp=TdDp,
    final uMinRetDam=uMinRetDam,
    final use_enthalpy=use_enthalpy,
    final delTOutHis=delTOutHis,
    final delEntHis=delEntHis,
    final retDamFulOpeTim=retDamFulOpeTim,
    final disDel=disDel,
    final samplePeriod=samplePeriod,
    final retDamPhyPosMax=retDamPhyPosMax,
    final retDamPhyPosMin=retDamPhyPosMin,
    final outDamPhyPosMax=outDamPhyPosMax,
    final outDamPhyPosMin=outDamPhyPosMin,
    final minOutDamPhyPosMax=minOutDamPhyPosMax,
    final minOutDamPhyPosMin=minOutDamPhyPosMin,
    final uHeaMax=uHeaMax,
    final uCooMin=uCooMin,
    final uOutDamMax=uOutDamMax,
    final uRetDamMin=uRetDamMin)
    "Economizer controller"
    annotation (Placement(transformation(extent={{80,-50},{100,-10}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyFan conSupFan(
    final have_perZonRehBox=have_perZonRehBox,
    final have_duaDucBox=have_duaDucBox,
    final have_airFloMeaSta=have_airFloMeaSta,
    final iniSet=pIniSet,
    final minSet=pMinSet,
    final maxSet=pMaxSet,
    final delTim=pDelTim,
    final samplePeriod=pSamplePeriod,
    final numIgnReq=pNumIgnReq,
    final triAmo=pTriAmo,
    final resAmo=pResAmo,
    final maxRes=pMaxRes,
    final controllerType=fanSpeCon,
    final k=kFanSpe,
    final Ti=TiFanSpe,
    final Td=TdFanSpe,
    final yFanMax=yFanMax,
    final yFanMin=yFanMin)
    "Supply fan speed setpoint"
    annotation (Placement(transformation(extent={{-220,510},{-200,530}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplySignals supSig(
    final have_heaCoi=have_heaCoi,
    final controllerType=valCon,
    final kTSup=kVal,
    final TiTSup=TiVal,
    final TdTSup=TdVal,
    final uHeaMax=uHeaCoiMax,
    final uCooMin=uCooCoiMin)
    "Heating and cooling valve position"
    annotation (Placement(transformation(extent={{-80,410},{-60,430}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature conTSupSet(
    final TSupCooMin=TSupCooMin,
    final TSupCooMax=TSupCooMax,
    final TOutMin=TOutMin,
    final TOutMax=TOutMax,
    final TSupWarUpSetBac=TSupWarUpSetBac,
    final delTim=delTimSupTem,
    final samplePeriod=samPerSupTem,
    final numIgnReq=ignReqSupTem,
    final triAmo=triAmoSupTem,
    final resAmo=resAmoSupTem,
    final maxRes=maxResSupTem)
    "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,450},{-140,470}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.AHU outAirSet(
    final VPriSysMax_flow=VPriSysMax_flow,
    final peaSysPop=peaSysPop)
    "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-80,190},{-60,210}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin(
    final nin=nZonGro)
    "Find the highest priotity operating mode"
    annotation (Placement(transformation(extent={{-300,560},{-280,580}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nZonGro]
    "Convert integer to real"
    annotation (Placement(transformation(extent={{-340,560},{-320,580}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger ahuMod
    "Air handling operating mode"
    annotation (Placement(transformation(extent={{-260,560},{-240,580}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefDamper relDam(
    final dpBuiSet=dpBuiSet,
    final k=kRelDam)
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
    annotation (Placement(transformation(extent={{-160,-350},{-140,-330}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefFan relFanCon(
    final nSupFan=nAHU,
    final nRelFan=nRelFan,
    final minSpe=minSpeRelFan,
    final staVec=staVec,
    final RelFanMat=RelFanMat,
    final dpBuiSet=dpBuiSet,
    final k=kRelFan)
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    annotation (Placement(transformation(extent={{-160,-400},{-140,-380}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReturnFanDirectPressure retFanDpCon(
    final dpBuiSet=dpBuiSet,
    final dpDisMin=dpDisMin,
    final dpDisMax=dpDisMax,
    final conTyp=retFanCon,
    final k=kRetFan,
    final Ti=TiRetFan,
    final Td=TdRetFan)
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp
    annotation (Placement(transformation(extent={{-160,-490},{-140,-470}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReturnFanAirflowTracking retFanAirTra(
    final difFloSet=difFloSet,
    final conTyp=retFanCon,
    final k=kRetFan,
    final Ti=TiRetFan,
    final Td=TdRetFan)
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
    annotation (Placement(transformation(extent={{-160,-450},{-140,-430}})));

equation
  connect(uOpeMod, intToRea.u)
    annotation (Line(points={{-380,570},{-342,570}}, color={255,127,0}));
  connect(intToRea.y, mulMin.u)
    annotation (Line(points={{-318,570},{-302,570}}, color={0,0,127}));
  connect(mulMin.y, ahuMod.u)
    annotation (Line(points={{-278,570},{-262,570}}, color={0,0,127}));
  connect(conSupFan.uZonPreResReq, uZonPreResReq) annotation (Line(points={{-222,
          517},{-300,517},{-300,530},{-380,530}},      color={255,127,0}));
  connect(ducStaPre, conSupFan.ducStaPre) annotation (Line(points={{-380,490},{-300,
          490},{-300,512},{-222,512}},      color={0,0,127}));
  connect(conTSupSet.TOut, TOut) annotation (Line(points={{-162,467},{-320,467},
          {-320,460},{-380,460}}, color={0,0,127}));
  connect(conTSupSet.uZonTemResReq, uZonTemResReq) annotation (Line(points={{-162,
          463},{-310,463},{-310,430},{-380,430}},      color={255,127,0}));
  connect(uSupFan, conTSupSet.uSupFan) annotation (Line(points={{-380,390},{-300,
          390},{-300,457},{-162,457}},      color={255,0,255}));
  connect(uSupFan, supSig.uSupFan) annotation (Line(points={{-380,390},{-300,390},
          {-300,426},{-82,426}},     color={255,0,255}));
  connect(conTSupSet.TSupSet, supSig.TSupSet) annotation (Line(points={{-138,460},
          {-120,460},{-120,420},{-82,420}}, color={0,0,127}));
  connect(supSig.TSup, TSup) annotation (Line(points={{-82,414},{-290,414},{-290,
          350},{-380,350}}, color={0,0,127}));
  connect(sumDesZonPop, outAirSet.sumDesZonPop) annotation (Line(points={{-380,300},
          {-160,300},{-160,209},{-82,209}}, color={0,0,127}));
  connect(VSumDesPopBreZon_flow, outAirSet.VSumDesPopBreZon_flow) annotation (
      Line(points={{-380,270},{-168,270},{-168,207},{-82,207}}, color={0,0,127}));
  connect(VSumDesAreBreZon_flow, outAirSet.VSumDesAreBreZon_flow) annotation (
      Line(points={{-380,240},{-176,240},{-176,205},{-82,205}}, color={0,0,127}));
  connect(uDesSysVenEff, outAirSet.uDesSysVenEff) annotation (Line(points={{-380,
          210},{-182,210},{-182,203},{-82,203}}, color={0,0,127}));
  connect(VSumUncOutAir_flow, outAirSet.VSumUncOutAir_flow) annotation (Line(
        points={{-380,180},{-182,180},{-182,201},{-82,201}}, color={0,0,127}));
  connect(VSumSysPriAir_flow, outAirSet.VSumSysPriAir_flow) annotation (Line(
        points={{-380,150},{-176,150},{-176,199},{-82,199}}, color={0,0,127}));
  connect(uOutAirFra_max, outAirSet.uOutAirFra_max) annotation (Line(points={{-380,
          120},{-168,120},{-168,197},{-82,197}}, color={0,0,127}));
  connect(uSupFan, outAirSet.uSupFan) annotation (Line(points={{-380,390},{-300,
          390},{-300,193},{-82,193}}, color={255,0,255}));
  connect(ahuMod.y, conSupFan.uOpeMod) annotation (Line(points={{-238,570},{-230,
          570},{-230,528},{-222,528}},      color={255,127,0}));
  connect(ahuMod.y, conTSupSet.uOpeMod) annotation (Line(points={{-238,570},{-230,
          570},{-230,453},{-162,453}},      color={255,127,0}));
  connect(ahuMod.y, outAirSet.uOpeMod) annotation (Line(points={{-238,570},{-230,
          570},{-230,191},{-82,191}},   color={255,127,0}));
  connect(conSupFan.ySupFan, ySupFan) annotation (Line(points={{-198,527},{-110,
          527},{-110,550},{380,550}},color={255,0,255}));
  connect(plaReq.yChiWatResReq, yChiWatResReq) annotation (Line(points={{2,-522},
          {330,-522},{330,-460},{380,-460}},       color={255,127,0}));
  connect(plaReq.yChiPlaReq, yChiPlaReq) annotation (Line(points={{2,-527},{340,
          -527},{340,-490},{380,-490}},     color={255,127,0}));
  connect(plaReq.yHotWatResReq, yHotWatResReq) annotation (Line(points={{2,-533},
          {340,-533},{340,-540},{380,-540}},       color={255,127,0}));
  connect(plaReq.uCooCoi, uCooCoi) annotation (Line(points={{-22,-533},{-320,-533},
          {-320,-510},{-380,-510}},       color={0,0,127}));
  connect(uHeaCoi, plaReq.uHeaCoi) annotation (Line(points={{-380,-560},{-320,-560},
          {-320,-538},{-22,-538}},      color={0,0,127}));
  connect(outAirSet.effOutAir_normalized, ecoCon.VOutMinSet_flow_normalized)
    annotation (Line(points={{-58,195},{42,195},{42,-11},{78,-11}},   color={0,0,
          127}));
  connect(VOut_flow, VOut_flow_normalized.u1)
    annotation (Line(points={{-380,90},{-2,90}}, color={0,0,127}));
  connect(outAirSet.VDesOutAir_flow, VOut_flow_normalized.u2) annotation (Line(
        points={{-58,202},{-40,202},{-40,78},{-2,78}},   color={0,0,127}));
  connect(VOut_flow_normalized.y, ecoCon.VOut_flow_normalized) annotation (Line(
        points={{22,84},{34,84},{34,-14},{78,-14}},   color={0,0,127}));
  connect(ecoCon.uOutDamPos, uOutDamPos) annotation (Line(points={{78,-17},{26,-17},
          {26,50},{-380,50}},         color={0,0,127}));
  connect(ecoCon.uSupFanSpe, uSupFanSpe) annotation (Line(points={{78,-20},{18,-20},
          {18,20},{-380,20}},         color={0,0,127}));
  connect(ecoCon.dpMinOutDam, dpMinOutDam) annotation (Line(points={{78,-23},{10,
          -23},{10,-10},{-380,-10}},    color={0,0,127}));
  connect(supSig.uTSup, ecoCon.uTSup) annotation (Line(points={{-58,426},{-32,426},
          {-32,-26},{78,-26}},   color={0,0,127}));
  connect(TOut, ecoCon.TOut) annotation (Line(points={{-380,460},{-320,460},{-320,
          -32},{78,-32}},   color={0,0,127}));
  connect(TOutCut, ecoCon.TOutCut) annotation (Line(points={{-380,-40},{28,-40},
          {28,-34},{78,-34}},   color={0,0,127}));
  connect(ecoCon.hOut, hOut) annotation (Line(points={{78,-37},{34,-37},{34,-70},
          {-380,-70}},  color={0,0,127}));
  connect(hOutCut, ecoCon.hOutCut) annotation (Line(points={{-380,-100},{40,-100},
          {40,-39},{78,-39}},   color={0,0,127}));
  connect(uSupFan, ecoCon.uSupFan) annotation (Line(points={{-380,390},{-300,390},
          {-300,-43},{78,-43}},   color={255,0,255}));
  connect(ahuMod.y, ecoCon.uOpeMod) annotation (Line(points={{-238,570},{-230,570},
          {-230,-46},{78,-46}},   color={255,127,0}));
  connect(ecoCon.yOutDamPosMin, frePro.uOutDamPosMin) annotation (Line(points={{102,-12},
          {120,-12},{120,-171},{198,-171}},            color={0,0,127}));
  connect(TSup, frePro.TSup) annotation (Line(points={{-380,350},{-290,350},{-290,
          -185},{198,-185}}, color={0,0,127}));
  connect(frePro.uFreSta, uFreSta) annotation (Line(points={{198,-188},{104,-188},
          {104,-140},{-380,-140}}, color={255,0,255}));
  connect(frePro.uFreStaRes, uFreStaRes) annotation (Line(points={{198,-191},{96,
          -191},{96,-180},{-380,-180}}, color={255,0,255}));
  connect(frePro.uSofSwiRes, uSofSwiRes) annotation (Line(points={{198,-194},{120,
          -194},{120,-210},{-380,-210}}, color={255,0,255}));
  connect(uRetFanSpe, frePro.uRetFanSpe) annotation (Line(points={{-380,-240},{128,
          -240},{128,-200},{198,-200}}, color={0,0,127}));
  connect(frePro.uRelFanSpe, uRelFanSpe) annotation (Line(points={{198,-203},{136,
          -203},{136,-270},{-380,-270}}, color={0,0,127}));
  connect(frePro.TMix, TMix) annotation (Line(points={{198,-209},{144,-209},{144,
          -300},{-380,-300}}, color={0,0,127}));
  connect(outAirSet.VDesUncOutAir_flow, VDesUncOutAir_flow) annotation (Line(
        points={{-58,208},{230,208},{230,330},{380,330}}, color={0,0,127}));
  connect(outAirSet.yAveOutAirFraPlu, yAveOutAirFraPlu) annotation (Line(points={{-58,205},
          {240,205},{240,300},{380,300}},           color={0,0,127}));
  connect(outAirSet.VEffOutAir_flow, VEffOutAir_flow) annotation (Line(points={{-58,198},
          {250,198},{250,260},{380,260}},          color={0,0,127}));
  connect(outAirSet.yReqOutAir, yReqOutAir) annotation (Line(points={{-58,192},{
          260,192},{260,220},{380,220}}, color={255,0,255}));
  connect(ecoCon.yRelDamPos, yRelDamPos) annotation (Line(points={{102,-36},{280,
          -36},{280,50},{380,50}},    color={0,0,127}));
  connect(frePro.yFreProSta, ecoCon.uFreProSta) annotation (Line(points={{222,-205},
          {240,-205},{240,-70},{46,-70},{46,-49},{78,-49}},     color={255,127,0}));
  connect(ecoCon.yOutDamPos, frePro.uOutDamPos) annotation (Line(points={{102,-42},
          {128,-42},{128,-173},{198,-173}},  color={0,0,127}));
  connect(ecoCon.yRetDamPos, frePro.uRetDamPos) annotation (Line(points={{102,-24},
          {136,-24},{136,-182},{198,-182}},  color={0,0,127}));
  connect(supSig.yHea, frePro.uHeaCoi) annotation (Line(points={{-58,420},{152,420},
          {152,-176},{198,-176}}, color={0,0,127}));
  connect(conSupFan.ySupFanSpe, frePro.uSupFanSpe) annotation (Line(points={{-198,
          520},{-110,520},{-110,-197},{198,-197}}, color={0,0,127}));
  connect(supSig.yCoo, frePro.uCooCoi) annotation (Line(points={{-58,414},{144,414},
          {144,-206},{198,-206}}, color={0,0,127}));
  connect(frePro.yEneCHWPum, yEneCHWPum) annotation (Line(points={{222,-171},{300,
          -171},{300,-50},{380,-50}},   color={255,0,255}));
  connect(frePro.yRetDamPos, yRetDamPos) annotation (Line(points={{222,-175},{270,
          -175},{270,90},{380,90}}, color={0,0,127}));
  connect(frePro.yOutDamPos, yOutDamPos) annotation (Line(points={{222,-179},{290,
          -179},{290,10},{380,10}},   color={0,0,127}));
  connect(ecoCon.yMinOutDamPos, frePro.uMinOutDamPos) annotation (Line(points={{102,-17},
          {112,-17},{112,-179},{198,-179}},            color={0,0,127}));
  connect(frePro.yMinOutDamPos, yMinOutDamPos) annotation (Line(points={{222,-183},
          {260,-183},{260,130},{380,130}}, color={0,0,127}));
  connect(frePro.ySupFanSpe, ySupFanSpe) annotation (Line(points={{222,-187},{310,
          -187},{310,-90},{380,-90}},   color={0,0,127}));
  connect(frePro.yRetFanSpe, yRetFanSpe) annotation (Line(points={{222,-191},{320,
          -191},{320,-120},{380,-120}}, color={0,0,127}));
  connect(frePro.yCooCoi, yCooCoi) annotation (Line(points={{222,-199},{310,-199},
          {310,-210},{380,-210}}, color={0,0,127}));
  connect(frePro.yHeaCoi, yHeaCoi) annotation (Line(points={{222,-202},{300,-202},
          {300,-240},{380,-240}}, color={0,0,127}));
  connect(intSwi.y, yHotWatPlaReq)
    annotation (Line(points={{322,-570},{380,-570}}, color={255,127,0}));
  connect(plaReq.yHotWatPlaReq, intSwi.u3) annotation (Line(points={{2,-538},{160,
          -538},{160,-578},{298,-578}}, color={255,127,0}));
  connect(freProMod.y, intSwi.u2) annotation (Line(points={{202,-560},{220,-560},
          {220,-570},{298,-570}}, color={255,0,255}));
  connect(frePro.yRelFanSpe, yRelFanSpe) annotation (Line(points={{222,-195},{330,
          -195},{330,-150},{380,-150}}, color={0,0,127}));
  connect(relDam.dpBui, dpBui)
    annotation (Line(points={{-162,-334},{-380,-334}}, color={0,0,127}));
  connect(relDam.yRelDam, yRelDamPos) annotation (Line(points={{-138,-340},{280,
          -340},{280,50},{380,50}},   color={0,0,127}));
  connect(relFanCon.yDpBui, yDpBui) annotation (Line(points={{-138,-384},{200,-384},
          {200,-280},{380,-280}}, color={0,0,127}));
  connect(dpBui, relFanCon.dpBui) annotation (Line(points={{-380,-334},{-280,-334},
          {-280,-390},{-162,-390}}, color={0,0,127}));
  connect(retFanAirTra.yRetFan, yRetFanSpe) annotation (Line(points={{-138,-440},
          {320,-440},{320,-120},{380,-120}}, color={0,0,127}));
  connect(retFanAirTra.VSup_flow, VSup_flow) annotation (Line(points={{-162,-434},
          {-320,-434},{-320,-430},{-380,-430}}, color={0,0,127}));
  connect(retFanAirTra.VRet_flow, VRet_flow)
    annotation (Line(points={{-162,-440},{-320,-440},{-320,-470},{-380,-470}},
                                                       color={0,0,127}));
  connect(dpBui, retFanDpCon.dpBui) annotation (Line(points={{-380,-334},{-280,-334},
          {-280,-474},{-162,-474}}, color={0,0,127}));
  connect(retFanDpCon.yDpBui, yDpBui) annotation (Line(points={{-138,-472},{200,
          -472},{200,-280},{380,-280}},                color={0,0,127}));
  connect(retFanDpCon.yExhDam, yExhDam) annotation (Line(points={{-138,-478},{300,
          -478},{300,-380},{380,-380}}, color={0,0,127}));
  connect(retFanDpCon.dpDisSet, dpDisSet) annotation (Line(points={{-138,-486},{
          310,-486},{310,-410},{380,-410}}, color={0,0,127}));
  connect(uSupFan, relDam.uSupFan) annotation (Line(points={{-380,390},{-300,390},
          {-300,-346},{-162,-346}}, color={255,0,255}));
  connect(uSupFan, retFanAirTra.uSupFan) annotation (Line(points={{-380,390},{-300,
          390},{-300,-446},{-162,-446}}, color={255,0,255}));
  connect(uSupFan, retFanDpCon.uSupFan) annotation (Line(points={{-380,390},{-300,
          390},{-300,-486},{-162,-486}}, color={255,0,255}));
  connect(relFanCon.uSupFan, uSupFanSet) annotation (Line(points={{-162,-384},{-260,
          -384},{-260,-370},{-380,-370}}, color={255,0,255}));
  connect(relFanCon.uRelFan, uRelFan) annotation (Line(points={{-162,-396},{-260,
          -396},{-260,-400},{-380,-400}}, color={255,0,255}));
  connect(relFanCon.yRelFanSpe, yRelFanSpeSet) annotation (Line(points={{-138,-390},
          {210,-390},{210,-310},{380,-310}}, color={0,0,127}));
  connect(relFanCon.yDam, yDam) annotation (Line(points={{-138,-396},{220,-396},
          {220,-350},{380,-350}}, color={0,0,127}));
  connect(TSup, plaReq.TSup) annotation (Line(points={{-380,350},{-290,350},{-290,
          -522},{-22,-522}}, color={0,0,127}));
  connect(conTSupSet.TSupSet, plaReq.TSupSet) annotation (Line(points={{-138,460},
          {-120,460},{-120,-527},{-22,-527}}, color={0,0,127}));
  connect(frePro.yFreProSta, freProMod.u) annotation (Line(points={{222,-205},{240,
          -205},{240,-500},{170,-500},{170,-560},{178,-560}}, color={255,127,0}));
  connect(frePro.yHotWatPlaReq, intSwi.u1) annotation (Line(points={{222,-207},{
          250,-207},{250,-562},{298,-562}}, color={255,127,0}));

annotation (
  defaultComponentName="mulAHUCon",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-440},{200,440}}),
    graphics={
      Rectangle(extent={{200,440},{-200,-440}},
                lineColor={0,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
       Text(extent={{-200,520},{200,440}},
          textString="%name",
          lineColor={0,0,255}),
       Text(extent={{-196,222},{-74,198}},
          lineColor={0,0,0},
          textString="VSumDesPopBreZon_flow"),
       Text(extent={{-196,200},{-70,178}},
          lineColor={0,0,0},
          textString="VSumDesAreBreZon_flow"),
       Text(extent={{-194,258},{-112,242}},
          lineColor={0,0,0},
          textString="sumDesZonPop"),
       Text(extent={{-200,286},{-162,270}},
          lineColor={0,0,0},
          textString="TSup"),
       Text(extent={{-198,366},{-164,350}},
          lineColor={0,0,0},
          textString="TOut"),
       Text(extent={{-194,390},{-140,374}},
          lineColor={0,0,0},
          textString="ducStaPre"),
       Text(extent={{-196,168},{-114,152}},
          lineColor={0,0,0},
          textString="uDesSysVenEff"),
       Text(extent={{-194,138},{-88,120}},
          lineColor={0,0,0},
          textString="VSumUncOutAir_flow"),
       Text(extent={{-198,116},{-88,100}},
          lineColor={0,0,0},
          textString="VSumSysPriAir_flow"),
       Text(extent={{-194,90},{-112,74}},
          lineColor={0,0,0},
          textString="uOutAirFra_max"),
       Text(extent={{-196,58},{-138,40}},
          lineColor={0,0,0},
          textString="VOut_flow",
          visible=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
                  or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper)),
       Text(extent={{-196,30},{-126,10}},
          lineColor={0,0,0},
          textString="uOutDamPos",
          visible=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
                  or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP)),
       Text(extent={{-198,-2},{-122,-20}},
          lineColor={0,0,0},
          textString="uSupFanSpe",
          visible=(minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
                  or minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP)),
       Text(extent={{-198,-30},{-116,-48}},
          lineColor={0,0,0},
          textString="dpMinOutDam",
          visible=minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP),
       Text(extent={{-196,-70},{-148,-88}},
          lineColor={0,0,0},
          textString="TOutCut"),
       Text(extent={{-198,-90},{-162,-108}},
          lineColor={0,0,0},
          textString="hOut",
          visible=use_enthalpy),
       Text(extent={{-198,-110},{-146,-128}},
          lineColor={0,0,0},
          textString="hOutCut",
          visible=use_enthalpy),
       Text(extent={{-200,-218},{-128,-234}},
          lineColor={0,0,0},
          textString="uRetFanSpe",
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
                  or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)),
       Text(extent={{-200,-240},{-122,-258}},
          lineColor={0,0,0},
          textString="uRelFanSpe",
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan),
       Text(extent={{-200,-270},{-160,-288}},
          lineColor={0,0,0},
          textString="TMix"),
       Text(extent={{-198,-398},{-146,-416}},
          lineColor={0,0,0},
          textString="uCooCoi"),
       Text(extent={{-202,-420},{-140,-438}},
          lineColor={0,0,0},
          textString="uHeaCoi",
          visible=have_heaCoi),
       Text(extent={{140,-140},{202,-158}},
          lineColor={0,0,0},
          textString="yHeaCoi",
          visible=have_heaCoi),
       Text(extent={{138,-112},{200,-130}},
          lineColor={0,0,0},
          textString="yCooCoi"),
       Text(extent={{122,-70},{204,-86}},
          lineColor={0,0,0},
          textString="yRelFanSpe",
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan),
       Text(extent={{120,-42},{202,-58}},
          lineColor={0,0,0},
          textString="yRetFanSpe",
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
                   or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)),
       Text(extent={{118,-12},{200,-28}},
          lineColor={0,0,0},
          textString="ySupFanSpe"),
       Text(extent={{120,80},{202,64}},
          lineColor={0,0,0},
          textString="yOutDamPos"),
       Text(extent={{120,110},{202,94}},
          lineColor={0,0,0},
          textString="yRelDamPos",
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
                   or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
               and not buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp),
       Text(extent={{118,140},{202,124}},
          lineColor={0,0,0},
          textString="yRetDamPos"),
       Text(extent={{100,170},{198,152}},
          lineColor={0,0,0},
          textString="yMinOutDamPos",
          visible=not minOADes == Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper),
       Text(extent={{118,238},{200,222}},
          lineColor={0,0,0},
          textString="VEffOutAir_flow"),
       Text(extent={{96,270},{200,252}},
          lineColor={0,0,0},
          textString="yAveOutAirFraPlu"),
       Text(extent={{78,302},{200,284}},
          lineColor={0,0,0},
          textString="VDesUncOutAir_flow"),
       Text(extent={{-196,440},{-148,418}},
          lineColor={255,127,0},
          textString="uOpeMod"),
       Text(extent={{-196,422},{-114,398}},
          lineColor={255,127,0},
          textString="uZonPreResReq"),
       Text(extent={{-194,340},{-106,320}},
          lineColor={255,127,0},
          textString="uZonTemResReq"),
       Text(extent={{106,-298},{194,-318}},
          lineColor={255,127,0},
          textString="yChiWatResReq"),
       Text(extent={{124,-338},{202,-356}},
          lineColor={255,127,0},
          textString="yChiPlaReq"),
       Text(extent={{108,-378},{196,-398}},
          lineColor={255,127,0},
          textString="yHotWatResReq",
          visible=have_heaCoi),
       Text(extent={{108,-418},{196,-438}},
          lineColor={255,127,0},
          textString="yHotWatPlaReq",
          visible=have_heaCoi),
       Text(extent={{120,210},{208,192}},
          lineColor={255,0,255},
          textString="yReqOutAir"),
       Text(extent={{136,392},{204,372}},
          lineColor={255,0,255},
          textString="ySupFan"),
       Text(extent={{-202,320},{-134,300}},
          lineColor={255,0,255},
          textString="uSupFan"),
       Text(extent={{-198,-148},{-144,-168}},
          lineColor={255,0,255},
          textString="uFreSta",
          visible=have_freSta),
       Text(extent={{-194,-168},{-126,-188}},
          lineColor={255,0,255},
          textString="uFreStaRes",
          visible=have_freSta),
       Text(extent={{-196,-188},{-122,-208}},
          lineColor={255,0,255},
          textString="uSofSwiRes",
          visible=not have_freSta),
       Text(extent={{112,30},{200,12}},
          lineColor={255,0,255},
          textString="yEneCHWPum"),
       Text(
          extent={{-200,-300},{-156,-318}},
          lineColor={0,0,0},
          textString="dpBui",
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)),
       Text(
          extent={{-200,-382},{-140,-398}},
          lineColor={0,0,0},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir,
          textString="VRet_flow"),
       Text(
          extent={{-200,-362},{-140,-378}},
          lineColor={0,0,0},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir,
          textString="VSup_flow"),
       Text(
          extent={{-196,-318},{-122,-338}},
          lineColor={255,0,255},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="uSupFanSet"),
       Text(
          extent={{-198,-340},{-144,-360}},
          lineColor={255,0,255},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="uRelFan"),
       Text(
          extent={{142,-178},{204,-196}},
          lineColor={0,0,0},
          visible=(buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
               or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp),
          textString="yDpBui"),
       Text(
          extent={{110,-200},{194,-218}},
          lineColor={0,0,0},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="yRelFanSpeSet"),
       Text(
          extent={{142,-220},{204,-238}},
          lineColor={0,0,0},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan,
          textString="yDam"),
       Text(
          extent={{136,-240},{198,-258}},
          lineColor={0,0,0},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp,
          textString="yExhDam"),
       Text(
          extent={{138,-260},{200,-278}},
          lineColor={0,0,0},
          visible=buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp,
          textString="dpDisSet")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-360,-600},{360,600}})),
  Documentation(info="<html>
<p>
Block that is applied for multizone VAV AHU control. It outputs the supply fan status
and the operation speed, outdoor and return air damper position, supply air
temperature setpoint and the valve position of the cooling and heating coils.
It is implemented according to the Section 5.16 of ASHRAE Guideline 36, May 2020.
</p>
<p>
The sequence consists of eight types of subsequences.
</p>
<h4>Supply fan speed control</h4>
<p>
The fan speed control is implemented according to Section 5.16.1. It outputs
the boolean signal <code>ySupFan</code> to turn on or off the supply fan.
In addition, based on the pressure reset request <code>uZonPreResReq</code>
from the VAV zones controller, the
sequence resets the duct pressure setpoint, and uses this setpoint
to modulate the fan speed <code>ySupFanSpe</code> using a PI controller.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyFan\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyFan</a>
for more detailed description.
</p>
<h4>Minimum outdoor airflow setting</h4>
<p>
According to current occupany, supply operation status <code>ySupFan</code>,
zone temperatures and the discharge air temperature, the sequence computes the
minimum outdoor airflow rate setpoint, which is used as input for the economizer control.
More detailed information can be found in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow</a>.
</p>
<h4>Economizer control</h4>
<p>
The block outputs outdoor and return air damper position, <code>yOutDamPos</code> and
<code>yRetDamPos</code>. First, it computes the position limits to satisfy the minimum
outdoor airflow requirement. Second, it determines the availability of the economizer based
on the outdoor condition. The dampers are modulated to track the supply air temperature
loop signal, which is calculated from the sequence below, subject to the minimum outdoor airflow
requirement and economizer availability.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Controller</a>
for more detailed description.
</p>
<h4>Supply air temperature setpoint</h4>
<p>
Based on the Section 5.16.2, the sequence first sets the maximum supply air temperature
based on reset requests collected from each zone <code>uZonTemResReq</code>. The
outdoor temperature <code>TOut</code> and operation mode <code>uOpeMod</code> are used
along with the maximum supply air temperature, for computing the supply air temperature
setpoint. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature</a>
for more detailed description.
</p>
<h4>Coil valve control</h4>
<p>
The subsequence retrieves supply air temperature setpoint from previous sequence.
Along with the measured supply air temperature and the supply fan status, it
generates coil valve positions. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplySignals\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplySignals</a>
for more detailed description.
</p>
<h4>Freeze protection</h4>
<p>
Based on the Section 5.16.12, the sequence enables freeze protection if the
measured supply air temperature belows certain thresholds. There are three
protection stages. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.FreezeProtection\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.FreezeProtection</a>
for more detailed description.
</p>
<h4>Building pressure control</h4>
<p>
By selecting different building pressure control designs, which includes using actuated 
relief damper without fan, using actuated relief dampers with relief fan, using
return fan with direct building pressure control, or using return fan with airflow
tracking control, the sequences controls relief fans, relief dampers and return fans.
See belows sequences for more detailed description:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefDamper\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefDamper</a>
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefFan\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReliefFan</a>
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReturnFanAirflowTracking\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReturnFanAirflowTracking</a>
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReturnFanDirectPressure\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.ReturnFanDirectPressure</a>
</li>
</ul>
<h4>Plant request</h4>
<p>
According to the Section 5.16.16, the sequence send out heating or cooling plant requests
if the supply air temperature is below or above threshold value, or the heating or
cooling valves have been widely open for certain times. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.PlantRequests</a>
for more detailed description.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 20, 2021, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
