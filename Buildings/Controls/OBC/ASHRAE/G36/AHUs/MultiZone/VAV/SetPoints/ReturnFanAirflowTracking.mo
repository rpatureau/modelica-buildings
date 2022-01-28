within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints;
block ReturnFanAirflowTracking
  "Return fan control for AHUs using return fan with airflow tracking"
  parameter Real difFloSet(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Airflow differential between supply air and return air fans required to maintain building pressure at desired pressure";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController conTyp=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Fan controller"));
  parameter Real k(final unit="1") = 1
    "Gain, normalized using dpBuiSet"
    annotation (Dialog(group="Fan controller"));
  parameter Real Ti(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block"
    annotation (Dialog(group="Fan controller",
      enable=conTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
          or conTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Fan controller",
      enable=conTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or conTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VSup_flow(
    final unit="m3/s",
    final min = 0,
    final quantity="VolumeFlowRate") "Measured AHU supply airflow rate"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VRet_flow(
    final unit="m3/s",
    final min=0,
    final quantity="VolumeFlowRate") "Measured AHU return airflow rate"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetFan(
    final unit="1",
    final min=0,
    final max=1)
    "Return fan speed setpoint"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Check if relief damper should be enabled"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback conErr(
    u1(final unit="m3/s"),
    u2(final unit="m3/s"),
    y(final unit="m3/s"))
    "Control error"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conP(
    final controllerType=conTyp,
    final k=k,
    final Ti=Ti,
    final Td=Td)
    "Building static pressure controller"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerSpe(
    final k=0) "Disable return fan"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant difFlo(
    final k=difFloSet) "Return airflow less than supply airflow"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

equation
  connect(uSupFan, swi.u2)
    annotation (Line(points={{-120,-30},{58,-30}}, color={255,0,255}));
  connect(zerSpe.y, swi.u3)
    annotation (Line(points={{-58,-60},{40,-60},{40,-38},{58,-38}}, color={0,0,127}));
  connect(swi.y,yRetFan)
    annotation (Line(points={{82,-30},{120,-30}}, color={0,0,127}));
  connect(VSup_flow, conErr.u1)
    annotation (Line(points={{-120,80},{-42,80}}, color={0,0,127}));
  connect(difFlo.y, conErr.u2)
    annotation (Line(points={{-58,50},{-30,50},{-30,68}}, color={0,0,127}));
  connect(conErr.y, conP.u_s)
    annotation (Line(points={{-18,80},{-2,80}}, color={0,0,127}));
  connect(VRet_flow, conP.u_m)
    annotation (Line(points={{-120,20},{10,20},{10,68}}, color={0,0,127}));
  connect(conP.y, swi.u1)
    annotation (Line(points={{22,80},{40,80},{40,-22},{58,-22}}, color={0,0,127}));

annotation (
  defaultComponentName = "retFanAirTra",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
 Documentation(info="<html>
<p>
Sequence for controlling return fan <code>yRetFan</code> for AHUs using return fan
with airflow tracking.
It is implemented according to Section 5.16.11 of ASHRAE Guideline G36, May 2020.
</p>
<ul>
<li>
Return fan operates whenever associated supply fan is proven on
(<code>uSupFan = true</code>).
</li>
<li>
Return fan speed shall be controlled to maintain return airflow equal to supply
airflow less differential <code>difFloSet</code>, as determined per section 3.2.1.5.
</li>
<li>
Relief or exhaust dampers shall be enabled when the associated supply and return
fans are proven on and closed otherwise. Exhaust dampers shall modulate as the inverse
of the return air damper per section 5.16.2.3. This is implemented in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.ReturnFan\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.ReturnFan</a>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
May 20, 2021, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReturnFanAirflowTracking;
