within Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.Validation;
model Effectiveness
  "Test model for calculating the input effectiveness of a sensible and latent heat exchanger"
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.Effectiveness
    epsCal(
    epsLatCoo_nominal=0.6,
    epsLatCooPL=0.7,
    epsSenHea_nominal=0.7,
    epsLatHea_nominal=0.6,
    epsSenHeaPL=0.6,
    epsLatHeaPL=0.5,
    VSup_flow_nominal=1)
    "Effectiveness calculator"
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Sources.Ramp whSpe(
    height=0.7,
    duration=60,
    offset=0.3,
    startTime=60)
    "Wheel speed"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Ramp TSup(
    height=5,
    duration=60,
    offset=273.15 + 20,
    startTime=0)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Ramp TExh(
    height=20,
    duration=60,
    offset=273.15 + 15,
    startTime=0)
    "Exhaust air temperature"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Blocks.Sources.Ramp VSup(
    height=0.4,
    duration=60,
    offset=0.6,
    startTime=0)
    "Supply air flow rate"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp VExh(
    height=0.2,
    duration=60,
    offset=0.8,
    startTime=0)
    "Exhaust air flow rate"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation
  connect(VSup.y, epsCal.VSup_flow)
    annotation (Line(points={{-59,70},{-28,70},{
    -28,8},{-14,8}}, color={0,0,127}));
  connect(VExh.y, epsCal.VExh_flow)
    annotation (Line(points={{-59,30},{-40,30},{
    -40,4},{-14,4}}, color={0,0,127}));
  connect(whSpe.y, epsCal.wheSpe)
    annotation (Line(points={{-59,0},{-14,0}}, color={0,0,127}));
  connect(TSup.y, epsCal.TSup)
    annotation (Line(points={{-59,-40},{-40,-40},{-40,
    -4},{-14,-4}}, color={0,0,127}));
  connect(TExh.y, epsCal.TExh)
    annotation (Line(points={{-59,-80},{-28,-80},{-28,
    -8},{-14,-8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(Tolerance=1e-6, StopTime=120),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/AirToAirHeatRecovery/BaseClasses/Validation/Effectiveness.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.Effectiveness\">
Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.BaseClasses.Effectiveness</a>.
</p>
<p>
The input signals are configured as follows:
</p>
<ul>
<li>The temperature of the supply air, <i>TSup</i>, is larger than the temperature 
of the exhaust air, <i>TExh</i>, before <i>20s</i>;
After that, <i>TSup</i> is less than <i>TExh</i>, leading to a heating mode;
</li>
</ul>
<ul>
<li>
The supply air flow rate, <i>VSup</i>, and the exhaust air flow rate, <i>VExh</i>, change from 
0.6 to 1 and 0.8 to 1 
during the period from <i>0s</i> to <i>60s</i>, respectively.
They then stay constant;
</li>
</ul>
<ul>
<li> 
The wheel speed ratio, <i>wheSpe</i>, keeps constant during the period from 
<i>0s</i> to <i>60s</i> and then increases from 0.3 to 1
during the period from <i>60s</i> to <i>120s</i>.
</li> 
</ul>
<p>
The expected outputs are:
</p>
<ul>
<li>
The sensible effectiveness, <code>epsSen</code>, increases during the whole simulation period. The latent effectiveness, 
<code>epsLat</code>, decreases from <i>0s</i> to <i>20s</i> and then increases during the rest of the time;
</li>
</ul>
<ul>
<li>There are dramatic changes in the effectiveness, <code>epsSen</code> and <code>epsLat</code>, at around <i>20s</i> due to switching
from the cooling mode to the heating mode.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 29, 2022, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Effectiveness;
