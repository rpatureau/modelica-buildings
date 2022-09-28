within Buildings.Fluid.Storage.Plant.Examples;
model DualSource
  "A district system model with two sources and three users"

  extends Modelica.Icons.Example;

  package MediumCHW = Buildings.Media.Water "Medium model for CHW";
  package MediumCDW1 = Buildings.Media.Water "Medium model for CDW of chi1";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    final displayUnit="Pa")=
     300000
    "Nominal pressure difference";
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal(
    final displayUnit="degC")=
     12+273.15
    "Nominal temperature of CHW return";
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal(
    final displayUnit="degC")=
     7+273.15
    "Nominal temperature of CHW supply";
  parameter Modelica.Units.SI.Power QCooLoa_flow_nominal=5*4200*0.6
    "Nominal cooling load of one consumer";

// First source: chiller only
  Buildings.Fluid.Chillers.ElectricEIR chi1(
    redeclare final package Medium1 = MediumCDW1,
    redeclare final package Medium2 = MediumCHW,
    m1_flow_nominal=1.2*chi1.m2_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p2_start=500000,
    T2_start=T_CHWS_nominal,
    final per=perChi1)
    "Water cooled chiller (ports indexed 1 are on condenser side)"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-130,110})));
  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic perChi1(
    QEva_flow_nominal=-1E6,
    COP_nominal=3,
    PLRMax=1,
    PLRMinUnl=0.3,
    PLRMin=0.3,
    etaMotor=1,
    mEva_flow_nominal=0.7*m_flow_nominal,
    mCon_flow_nominal=1.2*perChi1.mEva_flow_nominal,
    TEvaLvg_nominal=280.15,
    capFunT={1,0,0,0,0,0},
    EIRFunT={1,0,0,0,0,0},
    EIRFunPLR={1,0,0},
    TEvaLvgMin=276.15,
    TEvaLvgMax=288.15,
    TConEnt_nominal=310.15,
    TConEntMin=303.15,
    TConEntMax=333.15) "Performance data for the chiller in plant 1"
                                                  annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-180,160},{-160,
            180}})));
 Buildings.Fluid.Movers.SpeedControlled_y pumSup1(
    redeclare package Medium = MediumCHW,
    per(pressure(
          dp=dp_nominal*{2,1.2,0},
          V_flow=(1.5*m_flow_nominal)/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=T_CHWR_nominal) "CHW supply pump for chi1"
                                                 annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-70,80})));
  Buildings.Fluid.FixedResistances.CheckValve cheValPumChi1(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=chi1.m2_flow_nominal,
    dpValve_nominal=0.1*dp_nominal,
    dpFixed_nominal=0.1*dp_nominal) "Check valve" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-110,80})));
  Buildings.Controls.Continuous.LimPID conPI_pumChi1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=100,
    reverseActing=true) "PI controller" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-70,230})));
  Modelica.Blocks.Sources.Constant set_TRet(k=12 + 273.15)
    "CHW return setpoint"
    annotation (Placement(transformation(extent={{40,220},{60,240}})));
  Buildings.Fluid.Sources.MassFlowSource_T souCDW1(
    redeclare package Medium = MediumCDW1,
    m_flow=1.2*chi1.m2_flow_nominal,
    T=305.15,
    nPorts=1) "Source representing CDW supply line" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,130})));
  Buildings.Fluid.Sources.Boundary_pT sinCDW1(
    redeclare final package Medium = MediumCDW1,
    final p=300000,
    final T=310.15,
    nPorts=1) "Sink representing CDW return line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-170,90})));
  Modelica.Blocks.Sources.Constant TEvaLvgSet(k=T_CHWS_nominal)
    "Evaporator leaving temperature setpoint" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,250})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant on(k=true)
    "Placeholder, chiller always on"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,210})));

// Second source: chiller and tank
  final parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nomPla2(
    allowRemoteCharging=true,
    mTan_flow_nominal=0.75*m_flow_nominal,
    mChi_flow_nominal=0.75*m_flow_nominal,
    dp_nominal=dp_nominal,
    T_CHWS_nominal=T_CHWS_nominal,
    T_CHWR_nominal=T_CHWS_nominal) "Nominal values for the second plant"
    annotation (Placement(transformation(extent={{-180,-100},{-160,-80}})));
  Buildings.Fluid.Storage.Plant.TankBranch tanBra(
    preDroTanBot(final dp_nominal=nomPla2.dp_nominal*0.05),
    preDroTanTop(final dp_nominal=nomPla2.dp_nominal*0.05),
    redeclare final package Medium = MediumCHW,
    final nom=nomPla2) "Tank branch, tank can be charged remotely" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-90})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ChillerBranch chiBra2(
    redeclare final package Medium = MediumCHW,
    final nom=nomPla2)
    "Chiller branch"
    annotation (Placement(transformation(extent={{-150,-100},{-130,-80}})));
  Buildings.Fluid.Storage.Plant.NetworkConnection netCon(
    redeclare final package Medium = MediumCHW,
    final nom=nomPla2,
    allowRemoteCharging=nomPla2.allowRemoteCharging,
    perPumSup(pressure(V_flow=nomPla2.m_flow_nominal/1.2*{0,2},
                              dp=nomPla2.dp_nominal*{2,0})))
    "Supply pump and valves that connect the plant to the district network"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Modelica.Blocks.Sources.BooleanTable uRemCha(
    table={3600/9*6,3600/9*8},
    startValue=false) "Tank is being charged remotely" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-170})));
  Modelica.Blocks.Sources.BooleanTable uTanDis(
    table={3600/9*1,3600/9*6,3600/9*8},
    startValue=false)
    "True = discharging; false = charging (either local or remote)" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-30})));
  Buildings.Fluid.Storage.Plant.Controls.RemoteCharging conRemCha
    "Control block for the secondary pump and valves"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-30})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mTanSet_flow(
    final realTrue=nomPla2.mTan_flow_nominal,
    final realFalse=-nomPla2.mTan_flow_nominal)
    "Set a positive flow rate when tank discharging and negative when charging"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-30})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mChiBra2Set_flow(
    final realTrue=0,
    final realFalse=nomPla2.mChi_flow_nominal)
    "Set the flow rate to a constant value whenever the tank is not being charged remotely"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,-130})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Tank charging remotely OR there is load"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-130})));

// Users
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.IdealUser ideUse1(
    redeclare final package Medium = MediumCHW,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.3*dp_nominal,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,190})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.IdealUser ideUse2(
    redeclare final package Medium = MediumCHW,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.3*dp_nominal,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,0})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.IdealUser ideUse3(
    redeclare final package Medium = MediumCHW,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.3*dp_nominal,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-170})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin_dpUsr(nin=3)
    "Min of pressure head measured from all users"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,250})));
  Modelica.Blocks.Sources.Constant set_dpUsr(final k=1)
    "Normalised consumer differential pressure setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,250})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysCat(uLow=0.05, uHigh=0.1)
    "Shut off at con.yVal = 0.05 and restarts at 0.1" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,-210})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax_yVal(nin=3)
    "Max of valve positions"
    annotation (Placement(transformation(extent={{60,-220},{40,-200}})));
  Modelica.Blocks.Sources.TimeTable set_QCooLoa1_flow(table=[0,0; 3600/9*1,0;
        3600/9*1,QCooLoa_flow_nominal; 3600/9*4,QCooLoa_flow_nominal; 3600/9*4,
        0; 3600,0])
    "Cooling load"
    annotation (Placement(transformation(extent={{140,200},{120,220}})));
  Modelica.Blocks.Sources.TimeTable set_QCooLoa2_flow(table=[0,0; 3600/9*2,0;
        3600/9*2,QCooLoa_flow_nominal; 3600/9*5,QCooLoa_flow_nominal; 3600/9*5,
        0; 3600,0])
    "Cooling load"
    annotation (Placement(transformation(extent={{140,10},{120,30}})));
  Modelica.Blocks.Sources.TimeTable set_QCooLoa3_flow(table=[0,0; 3600/9*3,0;
        3600/9*3,QCooLoa_flow_nominal; 3600/9*7,QCooLoa_flow_nominal; 3600/9*7,
        0; 3600,0])                                       "Cooling load"
    annotation (Placement(transformation(extent={{140,-160},{120,-140}})));
  Modelica.Blocks.Math.Gain gaiUsr1(k=1/ideUse1.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={130,170})));
  Modelica.Blocks.Math.Gain gaiUsr2(k=1/ideUse2.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={130,-20})));
  Modelica.Blocks.Math.Gain gaiUsr3(k=1/ideUse3.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={130,-190})));

// District pipe network
  Buildings.Experimental.DHC.Networks.Connection2Pipe con2PipPla2(
    redeclare package Medium = MediumCHW,
    final mDis_flow_nominal=m_flow_nominal,
    final mCon_flow_nominal=nomPla2.m_flow_nominal,
    final allowFlowReversal=true,
    final dpDis_nominal=0) "Two-pipe connection to the storage plant"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,-90})));
  Buildings.Experimental.DHC.Networks.Connection2Pipe con2PipPla1(
    redeclare package Medium = MediumCHW,
    final mDis_flow_nominal=m_flow_nominal,
    final mCon_flow_nominal=chi1.m2_flow_nominal,
    final allowFlowReversal=true,
    final dpDis_nominal=0) "Two-pipe connection to the chiller-only plant"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,110})));
  Buildings.Experimental.DHC.Networks.Connection2Pipe con2PipUse2(
    redeclare package Medium = MediumCHW,
    final mDis_flow_nominal=m_flow_nominal,
    final mCon_flow_nominal=ideUse2.m_flow_nominal,
    final allowFlowReversal=true,
    final dpDis_nominal=0) "Two-pipe connection to the user(s)"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-10,0})));
  Buildings.Fluid.FixedResistances.Junction junBou(
    redeclare final package Medium = MediumCHW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nomPla2.T_CHWS_nominal,
    tau=30,
    final m_flow_nominal={-nomPla2.m_flow_nominal,nomPla2.m_flow_nominal,1},
    final dp_nominal={0,0,0}) "Junction connected to the pressure boundary"
    annotation (Placement(transformation(extent={{-90,-74},{-70,-94}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    p(final displayUnit="Pa") = 101325,
    redeclare final package Medium = MediumCHW,
    nPorts=1) "Pressure boundary"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,-50})));
equation
  connect(set_TRet.y, ideUse1.TSet) annotation (Line(points={{61,230},{80,230},{
          80,198},{61,198}},color={0,0,127}));
  connect(set_TRet.y, ideUse2.TSet) annotation (Line(points={{61,230},{80,230},
          {80,8},{61,8}}, color={0,0,127}));
  connect(set_TRet.y, ideUse3.TSet) annotation (Line(points={{61,230},{80,230},{
          80,-162},{61,-162}},color={0,0,127}));
  connect(ideUse3.yVal_actual, mulMax_yVal.u[1]) annotation (Line(points={{61,-174},
          {100,-174},{100,-210.667},{62,-210.667}},                       color=
         {0,0,127}));
  connect(ideUse2.yVal_actual, mulMax_yVal.u[2]) annotation (Line(points={{61,-4},
          {100,-4},{100,-210},{62,-210}}, color={0,0,127}));
  connect(mulMax_yVal.y, hysCat.u)
    annotation (Line(points={{38,-210},{22,-210}}, color={0,0,127}));
  connect(set_dpUsr.y,conPI_pumChi1. u_s)
    annotation (Line(points={{-99,250},{-70,250},{-70,242}},
                                                   color={0,0,127}));
  connect(ideUse1.yVal_actual, mulMax_yVal.u[3]) annotation (Line(points={{61,186},
          {100,186},{100,-209.333},{62,-209.333}},        color={0,0,127}));
  connect(set_QCooLoa1_flow.y, ideUse1.QCooLoa_flow) annotation (Line(points={{119,210},
          {110,210},{110,194},{61,194}},   color={0,0,127}));
  connect(set_QCooLoa2_flow.y, ideUse2.QCooLoa_flow) annotation (Line(points={{
          119,20},{110,20},{110,4},{61,4}}, color={0,0,127}));
  connect(set_QCooLoa3_flow.y, ideUse3.QCooLoa_flow) annotation (Line(points={{119,
          -150},{110,-150},{110,-166},{61,-166}},
                                               color={0,0,127}));
  connect(ideUse1.dpUsr, gaiUsr1.u)
    annotation (Line(points={{61,182},{110,182},{110,170},{118,170}},
                                                       color={0,0,127}));
  connect(ideUse2.dpUsr, gaiUsr2.u) annotation (Line(points={{61,-8},{110,-8},{
          110,-20},{118,-20}}, color={0,0,127}));
  connect(ideUse3.dpUsr, gaiUsr3.u)
    annotation (Line(points={{61,-178},{110,-178},{110,-190},{118,-190}},
                                                          color={0,0,127}));
  connect(gaiUsr1.y,mulMin_dpUsr. u[1]) annotation (Line(points={{141,170},{150,
          170},{150,249.333},{-18,249.333}},
                                     color={0,0,127}));
  connect(gaiUsr2.y,mulMin_dpUsr. u[2]) annotation (Line(points={{141,-20},{150,
          -20},{150,250},{-18,250}},               color={0,0,127}));
  connect(gaiUsr3.y,mulMin_dpUsr. u[3]) annotation (Line(points={{141,-190},{
          150,-190},{150,250.667},{-18,250.667}},
                                          color={0,0,127}));
  connect(mulMin_dpUsr.y,conPI_pumChi1. u_m)
    annotation (Line(points={{-42,250},{-52,250},{-52,230},{-58,230}},
                                                             color={0,0,127}));
  connect(uTanDis.y, mTanSet_flow.u) annotation (Line(points={{-159,-30},{-142,-30}},
                              color={255,0,255}));
  connect(mChiBra2Set_flow.u, uRemCha.y) annotation (Line(points={{-162,-130},{-170,
          -130},{-170,-150},{-150,-150},{-150,-170},{-159,-170}},
                            color={255,0,255}));
  connect(chiBra2.mPumSet_flow,mChiBra2Set_flow. y)
    annotation (Line(points={{-136,-101},{-136,-130},{-138,-130}},
                                                             color={0,0,127}));
  connect(conPI_pumChi1.y,pumSup1. y) annotation (Line(points={{-70,219},{-70,92}},
                           color={0,0,127}));
  connect(pumSup1.port_b, cheValPumChi1.port_a)
    annotation (Line(points={{-80,80},{-100,80}}, color={0,127,255}));
  connect(cheValPumChi1.port_b, chi1.port_a2) annotation (Line(points={{-120,80},
          {-124,80},{-124,100}},          color={0,127,255}));
  connect(souCDW1.ports[1], chi1.port_a1) annotation (Line(points={{-160,130},{-136,
          130},{-136,120}},                     color={0,127,255}));
  connect(chi1.port_b1, sinCDW1.ports[1]) annotation (Line(points={{-136,100},{-136,
          90},{-160,90}},           color={0,127,255}));
  connect(TEvaLvgSet.y, chi1.TSet)
    annotation (Line(points={{-159,250},{-127,250},{-127,122}},
                                                           color={0,0,127}));
  connect(on.y, chi1.on) annotation (Line(points={{-158,210},{-133,210},{-133,122}},
                    color={255,0,255}));
  connect(uRemCha.y, or2.u1) annotation (Line(points={{-159,-170},{-150,-170},{-150,
          -150},{-50,-150},{-50,-142}},   color={255,0,255}));
  connect(hysCat.y, or2.u2) annotation (Line(points={{-2,-210},{-42,-210},{-42,-142}},
        color={255,0,255}));
  connect(conRemCha.uAva, or2.y) annotation (Line(points={{-38,-26},{-32,-26},{-32,
          -110},{-50,-110},{-50,-118}},
                     color={255,0,255}));
  connect(mTanSet_flow.y,conRemCha. mTanSet_flow) annotation (Line(points={{-118,
          -30},{-110,-30},{-110,-22},{-61,-22}},
                                               color={0,0,127}));
  connect(uRemCha.y,conRemCha. uRemCha) annotation (Line(points={{-159,-170},{-150,
          -170},{-150,-150},{-28,-150},{-28,-22},{-38,-22}},
        color={255,0,255}));
  connect(conRemCha.yPumSup,netCon. yPumSup)
    annotation (Line(points={{-52,-41},{-52,-79}}, color={0,0,127}));
  connect(conRemCha.yValSup,netCon. yValSup)
    annotation (Line(points={{-48,-41},{-48,-79}}, color={0,0,127}));
  connect(chiBra2.port_b, tanBra.port_aFroChi)
    annotation (Line(points={{-130,-84},{-120,-84}}, color={0,127,255}));
  connect(chiBra2.port_a, tanBra.port_bToChi)
    annotation (Line(points={{-130,-96},{-120,-96}}, color={0,127,255}));
  connect(tanBra.port_aFroNet, netCon.port_bToChi)
    annotation (Line(points={{-100,-96},{-60,-96}},color={0,127,255}));

  connect(tanBra.mTan_flow, conRemCha.mTan_flow)
    annotation (Line(points={{-106,-79},{-106,-26},{-61,-26}},
                                                             color={0,0,127}));
  connect(tanBra.port_bToNet, junBou.port_1)
    annotation (Line(points={{-100,-84},{-90,-84}}, color={0,127,255}));
  connect(junBou.port_2, netCon.port_aFroChi)
    annotation (Line(points={{-70,-84},{-60,-84}}, color={0,127,255}));
  connect(junBou.port_3, bou.ports[1])
    annotation (Line(points={{-80,-74},{-80,-60}}, color={0,127,255}));
  connect(netCon.port_aFroNet, con2PipPla2.port_aCon)
    annotation (Line(points={{-40,-96},{-20,-96}}, color={0,127,255}));
  connect(con2PipPla2.port_bCon, netCon.port_bToNet) annotation (Line(points={{
          -20,-90},{-34,-90},{-34,-84},{-40,-84}}, color={0,127,255}));
  connect(con2PipPla2.port_bDisSup, ideUse3.port_a) annotation (Line(points={{
          -10,-100},{-10,-154},{50,-154},{50,-160}}, color={0,127,255}));
  connect(ideUse3.port_b, con2PipPla2.port_aDisRet) annotation (Line(points={{
          50,-180},{50,-186},{-4,-186},{-4,-100}}, color={0,127,255}));
  connect(con2PipPla2.port_bDisRet, con2PipUse2.port_aDisSup) annotation (Line(
        points={{-4,-80},{-4,-16},{-10,-16},{-10,-10}}, color={0,127,255}));
  connect(con2PipPla2.port_aDisSup, con2PipUse2.port_bDisRet) annotation (Line(
        points={{-10,-80},{-10,-74},{-16,-74},{-16,-10}}, color={0,127,255}));
  connect(con2PipUse2.port_aCon, ideUse2.port_a) annotation (Line(points={{0,6},
          {32,6},{32,16},{50,16},{50,10}}, color={0,127,255}));
  connect(ideUse2.port_b, con2PipUse2.port_bCon) annotation (Line(points={{50,
          -10},{50,-16},{32,-16},{32,-5.55112e-16},{0,-5.55112e-16}}, color={0,
          127,255}));
  connect(con2PipUse2.port_aDisRet, con2PipPla1.port_bDisSup) annotation (Line(
        points={{-16,10},{-16,92},{-10,92},{-10,100}}, color={0,127,255}));
  connect(con2PipPla1.port_aDisRet, con2PipUse2.port_bDisSup) annotation (Line(
        points={{-4,100},{-4,18},{-10,18},{-10,10}}, color={0,127,255}));
  connect(con2PipPla1.port_aDisSup, ideUse1.port_a) annotation (Line(points={{
          -10,120},{-10,206},{50,206},{50,200}}, color={0,127,255}));
  connect(ideUse1.port_b, con2PipPla1.port_bDisRet) annotation (Line(points={{
          50,180},{50,174},{-4,174},{-4,120}}, color={0,127,255}));
  connect(con2PipPla1.port_bCon, chi1.port_b2) annotation (Line(points={{-20,
          110},{-30,110},{-30,130},{-124,130},{-124,120}}, color={0,127,255}));
  connect(pumSup1.port_a, con2PipPla1.port_aCon) annotation (Line(points={{-60,
          80},{-30,80},{-30,104},{-20,104}}, color={0,127,255}));
    annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Examples/DualSource.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-06, StopTime=3600),
        Diagram(coordinateSystem(extent={{-180,-220},{160,280}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
[fixme: Update documentation.]    
This is the base model of a district system model with
two CHW sources and three users with the following structure:
</p>
<p align=\"center\">
<img alt=\"DualSource\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/DualSource.png\"/>
</p>
<p>
The first source is a simplified CHW plant with only a chiller,
a single supply pump, and a check valve (with series resistance built in).
This supply pump is controlled to ensure that all users have enough pressure head.
</p>
<p>
The second source has a chiller and a stratified CHW tank. Its piping is arranged
in a way that allows the tank to be charged remotely by the other source.
Its supply pump is controlled to maintain the flow rate setpoint of the tank.
This plant is disconnected when the largest position of user control valves
less than 5% open and connected back when this value is higher than 10%.
</p>
<p>
The timetables give the system the following behaviour:
</p>
<table summary= \"system modes\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th>Time slots</th>
    <th>1</th>
    <th>2</th>
    <th>3</th>
    <th>4</th>
    <th>5</th>
    <th>6</th>
    <th>7</th>
    <th>8</th>
    <th>9</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>User 1</td>
    <td>-</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>User 2</td>
    <td>-</td>
    <td>-</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>User 3</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Tank <br>(being charged)</td>
    <td>Local</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>Remote</td>
    <td>Remote</td>
    <td>-</td>
  </tr>
</tbody>
</table>
</html>", revisions="<html>
<ul>
<li>
September 28, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end DualSource;