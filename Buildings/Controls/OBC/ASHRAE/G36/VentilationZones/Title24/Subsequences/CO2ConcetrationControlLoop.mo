within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.Subsequences;
block CO2ConcetrationControlLoop
  "COntrol loop that maintains the CO2 concentration at setpoint"
  parameter Real minExhDamPos(
    min=0,
    max=1,
    final unit="1") = 0.2
    "Exhaust damper position maintaining building static pressure at setpoint when the system is at minPosMin"
    annotation(Dialog(group="Nominal parameters"));
  parameter Real maxExhDamPos(
    min=0,
    max=1,
    final unit="1") = 0.9
    "Exhaust damper position maintaining building static pressure at setpoint when outdoor air damper is fully open and fan speed is at cooling maximum"
    annotation(Dialog(group="Nominal parameters"));
  parameter Real minOutPosMin(
    min=0,
    max=1,
    final unit="1") = 0.4
    "Outdoor air damper position when fan operating at minimum speed to supply minimum outdoor air flow"
    annotation(Dialog(group="Nominal parameters"));
  parameter Real outDamPhyPosMax(
    min=0,
    max=1,
    final unit="1")=1
    "Physical or at the comissioning fixed maximum position of the outdoor air damper"
    annotation(Dialog(group="Nominal parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPos(
    min=0,
    max=1,
    final unit="1")
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yExhDamPos(
    min=0,
    max=1,
    final unit="1") "Exhaust damper position"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation

annotation (
  defaultComponentName = "exhDam",
  Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,78},{-42,40}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOutDamPos"),
        Text(
          extent={{-94,-48},{-62,-72}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uSupFan"),
        Text(
          extent={{46,18},{96,-18}},
          lineColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yExhDamPos"),
        Polygon(
          points={{-46,92},{-54,70},{-38,70},{-46,92}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-46,82},{-46,-86}}, color={192,192,192}),
        Line(points={{-56,-78},{68,-78}}, color={192,192,192}),
        Polygon(
          points={{72,-78},{50,-70},{50,-86},{72,-78}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-46,-78},{14,62},{80,62}}, color={0,0,127}),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name")}),
   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
 Documentation(info="<html>

<p>
fixme
</p>
<p align=\"center\">
<img alt=\"Image of the exhaust damper control chart for single zone AHU\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/SetPoints/ExhaustDamper.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
Jun 20, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end CO2ConcetrationControlLoop;
