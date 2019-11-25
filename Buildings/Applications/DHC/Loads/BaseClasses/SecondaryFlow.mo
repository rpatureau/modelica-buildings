within Buildings.Applications.DHC.Loads.BaseClasses;
model SecondaryFlow "Model for computing secondary flow distribution based on terminal units demands"
  // Suffix _i is to distinguish vector variable from (total) scalar variable on the source side (1) only.
  // Each variable related to load side (2) quantities is a vector by default.
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=Medium1,
    final m_flow_nominal=m_flow1_nominal,
    final allowFlowReversal=false);
  replaceable package Medium1 =
    Buildings.Media.Water
    "Source side medium"
      annotation (choices(
        choice(redeclare package Medium1 = Buildings.Media.Water "Water"),
        choice(redeclare package Medium1 =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));
  parameter Integer nLoa = 1
    "Number of connected loads";
  parameter Modelica.SIunits.MassFlowRate m_flow1_nominal
    "Source side total mass flow rate at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp1_nominal(
    min=0, displayUnit="Pa") = 0
    "Source side total pressure drop at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a1_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Source side supply temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b1_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Source side return temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics = energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.SIunits.Time tau = 30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  // Advanced
  parameter Boolean homotopyInitialization = true
    "If true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  // IO connectors
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow1Req_i[nLoa](
    each quantity="MassFlowRate")
    "Heating or chilled water flow required to meet the load" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,220}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput m_flow1Req(
    quantity="MassFlowRate") "Heating or chilled water flow required to meet the load"
    annotation (Placement(transformation(extent={{100,200},
            {140,240}}),iconTransformation(extent={{100,60},{140,100}})));
  // Building blocks
  Buildings.Fluid.Sensors.TemperatureTwoPort T_a1Mes(
    redeclare final package Medium = Medium1, final m_flow_nominal=m_flow1_nominal) annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sensors.MassFlowRate m_flow1Mes(redeclare final package Medium=Medium1)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator T_a1MesVec(nout=nLoa) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-70,30})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo(
    redeclare final package Medium=Medium1,
    final dp_nominal=dp1_nominal,
    final m_flow_nominal=m_flow1_nominal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final tau=tau,
    T_start=T_a1_nominal,
    final Q_flow_nominal=1,
    final allowFlowReversal=allowFlowReversal)
    "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(k=fill(1, nLoa), nin=1)
    "Total required water mass flow rate" annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Buildings.Fluid.Sources.MassFlowSource_T m_flow1Sou_i[nLoa](
    redeclare each final package Medium = Medium1,
    each use_m_flow_in=true,
    each use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{62,150},{82,170}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1[nLoa](
    redeclare each final package Medium=Medium1,
    p(each start=Medium1.p_default),
    m_flow(each min=0),
    h_outflow(each start=Medium1.h_default, each nominal=Medium1.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)" annotation (Placement(transformation(
          extent={{-110,150},{-90,170}}), iconTransformation(extent={{90,30},{110,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1[nLoa](
    redeclare each final package Medium=Medium1,
    p(each start=Medium1.p_default),
    m_flow(each max=0),
    h_outflow(each start=Medium1.h_default, each nominal=Medium1.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,150},{90,170}}),
    iconTransformation(extent={{-90,30},{-110,50}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium=Medium1,
    nPorts=1)    annotation (Placement(transformation(extent={{-60,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum Q_flow1Sum(nin=1)
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow1Act(each quantity="HeatFlowRate")
    "Heat flow rate transferred to the source" annotation (Placement(transformation(extent={{100,80},{140,120}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Q_flow1Act_i[nLoa](
    each quantity="HeatFlowRate")
    "Heat flow rate transferred to the source" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-80})));
  Modelica.Blocks.Sources.RealExpression m_flow1Act_i[nLoa](y=m_flow1Req_i .*
        Buildings.Utilities.Math.Functions.smoothMin(
        1,
        m_flow1Mes.m_flow/Buildings.Utilities.Math.Functions.smoothMax(
          m_flow1Req,
          m_flow_small,
          m_flow_small),
        1E-2))
    "Actual mass flow rate (constrained by sum(m_flow1Act_i)=m_flow1Mes)"
    annotation (Placement(transformation(extent={{0,170},{20,190}})));
equation
  connect(port_a,T_a1Mes.port_a) annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(T_a1Mes.port_b, m_flow1Mes.port_a) annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(T_a1Mes.T, T_a1MesVec.u) annotation (Line(points={{-70,11},{-70,18}}, color={0,0,127}));
  connect(m_flow1Mes.port_b, heaCoo.port_a) annotation (Line(points={{-20,0},{60,0}}, color={0,127,255}));
  connect(heaCoo.port_b, port_b) annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(mulSum.y, m_flow1Req) annotation (Line(points={{-58,220},{120,220}},               color={0,0,127}));
  connect(Q_flow1Sum.y, heaCoo.u) annotation (Line(points={{22,100},{40,100},{40,6},{58,6}}, color={0,0,127}));
  connect(port_a1, sin.ports[1:1]) annotation (Line(points={{-100,160},{-80,160}}, color={0,127,255}));
  connect(T_a1MesVec.y, m_flow1Sou_i.T_in)
    annotation (Line(points={{-70,42},{-70,140},{40,140},{40,164},{60,164}}, color={0,0,127}));
  connect(m_flow1Req_i, mulSum.u[1:1]) annotation (Line(points={{-120,220},{-82,220}}, color={0,0,127}));
  connect(Q_flow1Act_i, Q_flow1Sum.u[1:1]) annotation (Line(points={{-120,100},{-2,100}}, color={0,0,127}));
  connect(m_flow1Act_i.y, m_flow1Sou_i.m_flow_in)
    annotation (Line(points={{21,180},{40,180},{40,168},{60,168}}, color={0,0,127}));
  connect(m_flow1Sou_i.ports[1], port_b1) annotation (Line(points={{82,160},{100,160}}, color={0,127,255}));
  connect(Q_flow1Sum.y, Q_flow1Act) annotation (Line(points={{22,100},{120,100}}, color={0,0,127}));
annotation (
defaultComponentName="secFlo",
Documentation(
info="<html>
<p>
This model computes the steady-state, sensible heat transfer between a circulating liquid and idealized
thermal loads at uniform temperature.
</p>
<p>
The heat flow rate transferred to each load is computed using the effectiveness method, see
<a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessDirect\">
Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessDirect</a>.
As the effectiveness depends on the mass flow rate, this requires to assess a representative distribution of
the main liquid stream between the connected loads.
This is achieved by:
<ul>
<li> computing the mass flow rate needed to transfer the required heat flow rate to each load,
see
<a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessControl\">
Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessControl</a>,
</li>
<li> normalizing this mass flow rate to the actual flow rate of the main liquid stream.</li>
</ul>
</p>
<p>
The nominal UA-value (W/K) is calculated for each load <i>i</i> from the cooling or
heating power and the temperature difference between the liquid and the load, see
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ\">
Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ</a>.
It is split between an internal (liquid side) and an external (load side) UA-value based on the ratio
<i>UA<sub>int, nom, i</sub> / UA<sub>ext, nom, i</sub> </i> provided as a parameter. The influence of
the liquid flow rate on the internal UA-value is derived from a forced convection
correlation, expressing the Nusselt number as a power of the Reynolds number, under the assumption that the
physical characteristics of the liquid do not vary significantly from their value at nominal conditions.
</p>
<p align=\"center\" style=\"font-style:italic;\">
UA<sub>int, i</sub> = UA<sub>int, nom, i</sub> * (m&#775;<sub>i</sub> /
m&#775;<sub>nom, i</sub>)<sup>expUAi</sup>
</p>
<p>
where thedefault value of <i>expUA<sub>i</sub></i> stems from the Dittus and Boelter correlation for turbulent
flow.
</p>

<h4>References</h4>
<p>
Dittus and Boelter. 1930. Heat transfer in automobile radiators of the tubular type. University of California
Engineering Publication 13.443.
</p>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
          extent={{-70,70},{70,-70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,5},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={95,95,95}),
        Rectangle(
          extent={{0,-4},{100,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{100,240}}), graphics={Text(
          extent={{-34,272},{42,218}},
          lineColor={28,108,200},
          textString="Need to devise how different distribution temperatures are handled.")}));
end SecondaryFlow;
