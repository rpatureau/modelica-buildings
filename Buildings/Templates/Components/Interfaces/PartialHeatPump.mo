within Buildings.Templates.Components.Interfaces;
model PartialHeatPump
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=MediumLoa,
    final m_flow_nominal=max(mHeaWat_flow_nominal, mChiWat_flow_nominal));

  replaceable package MediumLoa=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Load-side medium"
    annotation(__Linkage(enable=false));

  /*
  The following definition is needed only for Dymola that does not allow
  port_aSou and port_bSou to be instantiated without redeclaring their medium
  to a non-partial class (which is done only in the derived class).
  */
  replaceable package MediumSou=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Source-side medium"
    annotation(__Linkage(enable=false));

  parameter Buildings.Templates.Components.Types.HeatPump typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean is_rev
    "Set to true for reversible heat pumps, false for heating only"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.HeatPumpModel typMod
    "Type of heat pump model"
    annotation (Evaluate=true, Dialog(group="Configuration"),
    __ctrlFlow(enable=false));

  parameter Buildings.Templates.Components.Data.HeatPump dat(
    typ=typ,
    is_rev=is_rev,
    typMod=typMod,
    cpHeaWat_default=cpHeaWat_default,
    cpChiWat_default=cpHeaWat_default)
    "Design and operating parameters"
    annotation (
    Placement(transformation(extent={{70,80},{90,100}})),
    __ctrlFlow(enable=false));

  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal=
    dat.mHeaWat_flow_nominal
    "HW mass flow rate";
  final parameter Modelica.Units.SI.HeatFlowRate capHea_nominal=
    dat.capHea_nominal
    "Heating capacity";
  final parameter Modelica.Units.SI.PressureDifference dpHeaWat_nominal=
    dat.dpHeaWat_nominal
    "Pressure drop at design HW mass flow rate";
  final parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=
    dat.THeaWatSup_nominal
    "HW supply temperature";
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal=
    dat.mChiWat_flow_nominal
    "CHW mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.PressureDifference dpChiWat_nominal=
    dpHeaWat_nominal * (mChiWat_flow_nominal / mHeaWat_flow_nominal)^2
    "Pressure drop at design HW mass flow rate";
  final parameter Modelica.Units.SI.HeatFlowRate capCoo_nominal=
    dat.capCoo_nominal
    "Cooling capacity";
  final parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=
    dat.TChiWatSup_nominal
    "(Lowest) CHW supply temperature";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Conservation equations"));

  final parameter MediumLoa.SpecificHeatCapacity cpHeaWat_default=
    MediumLoa.specificHeatCapacityCp(staHeaWat_default)
    "HW default specific heat capacity";
  final parameter MediumLoa.ThermodynamicState staHeaWat_default=
    MediumLoa.setState_pTX(
      T=THeaWatSup_nominal,
      p=MediumLoa.p_default,
      X=MediumLoa.X_default)
    "HW default state";
  final parameter MediumLoa.SpecificHeatCapacity cpChiWat_default=
    MediumLoa.specificHeatCapacityCp(staChiWat_default)
    "CHW default specific heat capacity";
  final parameter MediumLoa.ThermodynamicState staChiWat_default=
    MediumLoa.setState_pTX(
      T=TChiWatSup_nominal,
      p=MediumLoa.p_default,
      X=MediumLoa.X_default)
    "CHW default state";

  Modelica.Fluid.Interfaces.FluidPort_a port_aSou(
    redeclare package Medium = MediumSou)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(
      iconVisible=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater,
      transformation(extent={{30,-110},{50,-90}}),
      iconTransformation(extent={{40,-110},{60,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSou(
    redeclare package Medium = MediumSou)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(
      iconVisible=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater,
      transformation(extent={{-30,-110},{-50,-90}}),
      iconTransformation(extent={{-40,-110},{-60,-90}})));
  Buildings.Templates.Components.Interfaces.Bus bus
    "Control bus"
    annotation (Placement(transformation(extent={{-20,80},{20,120}}),
     iconTransformation(extent={{-20,80},{20, 120}})));
  BoundaryConditions.WeatherData.Bus busWea
    if typ==Buildings.Templates.Components.Types.HeatPump.AirToWater
    "Weather bus"
    annotation (Placement(transformation(extent={{-80,80},{-40,120}}),
        iconTransformation(extent={{-80,80},{-40,120}})));
  Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium=MediumSou,
    nPorts=2)
    if typ==Buildings.Templates.Components.Types.HeatPump.AirToWater
    "Outdoor air"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-90})));
initial equation
  // For reversible heat pumps, check that placeholder parameter values in cooling
  // mode are not used.
  if is_rev and typMod==Buildings.Templates.Components.Types.HeatPumpModel.EquationFit then
    assert(abs(dat.per.coo.TRefSou-273.15)>Modelica.Constants.eps,
      "In " + getInstanceName() +
      ": The parameter dat.per.coo.TRefSou has not been modified from its default value (" +
      String(273.15) + " K)" +
      "although the model is configured for reversible heat pumps." +
      "This is likely an error that will yield incorrect results.",
      level = AssertionLevel.warning);
    assert(abs(dat.per.coo.P)>Modelica.Constants.eps,
      "In " + getInstanceName() +
      ": The parameter dat.per.coo.P has not been modified from its default value (" +
      "0)" +
      "although the model is configured for reversible heat pumps." +
      "This is likely an error that will yield incorrect results.",
      level = AssertionLevel.warning);
    assert(not Modelica.Math.Vectors.isEqual(dat.per.coo.coeQ, {1,0,0,0,0}),
      "In " + getInstanceName() +
      ": The parameter dat.per.coo.coeQ has not been modified from its default value (" +
      "{1,0,0,0,0})" +
      "although the model is configured for reversible heat pumps." +
      "This is likely an error that will yield incorrect results.",
      level = AssertionLevel.warning);
    assert(not Modelica.Math.Vectors.isEqual(dat.per.coo.coeP, {1,0,0,0,0}),
      "In " + getInstanceName() +
      ": The parameter dat.per.coo.coeP has not been modified from its default value (" +
      "{1,0,0,0,0})" +
      "although the model is configured for reversible heat pumps." +
      "This is likely an error that will yield incorrect results.",
      level = AssertionLevel.warning);
  end if;
equation
  connect(bou.ports[1], port_bSou)
    annotation (Line(points={{-1,-80},{-40,-80},{-40,-100}}, color={0,127,255}));
  connect(bou.ports[2], port_aSou) annotation (
    Line(points={{1,-80},{40,-80},{40,-100}}, color={0,127,255}));
annotation (
Icon(graphics={
    Rectangle(
          extent={{100,60},{-100,-100}},
          lineColor={0,0,0},
          lineThickness=1),
    Bitmap(extent={{-20,60},{20,100}}, fileName=
    "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg"),
    Text( extent={{-60,-20},{60,-60}},
          textColor={0,0,0},
          textString="HP")}), Documentation(info="<html>
RFE: Add check for design capacity below the one computed
from reference values (per record).
</html>"));
end PartialHeatPump;
