within Buildings.Fluid.Storage.Ice.Examples.BaseClasses;
block ControlEfficiencyMode
  "Closed loop control for ice storage plant in efficiency mode"

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demLev "Demand level" annotation (
    Placement(visible = true, transformation(origin={-260,180},   extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin={-260,200},   extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Controls.OBC.CDL.Interfaces.BooleanOutput yWatChi "If true, enable water chiller operation" annotation (
    Placement(transformation(extent={{240,0},{280,40}}), iconTransformation(
          extent={{240,0},{280,40}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yGlyChi "If true, enable glycol chiller operation" annotation (
    Placement(transformation(extent={{240,-40},{280,0}}), iconTransformation(
          extent={{240,-40},{280,0}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput
                                         yStoOn
    "Control signal for storage main leg"
    annotation (Placement(transformation(extent={{240,100},{280,140}}),
        iconTransformation(extent={{240,100},{280,140}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput
                                         yStoByp
    "Control signal for storage bypass leg"
    annotation (Placement(transformation(extent={{240,60},{280,100}}),
        iconTransformation(extent={{240,60},{280,100}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput
                                         yPumSto
    "Pump speed ice storage" annotation (Placement(transformation(extent={{240,-100},
            {280,-60}}), iconTransformation(extent={{240,-100},{280,-60}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yPumGlyChi
    "Pump speed glycol chiller" annotation (Placement(transformation(extent={{
            240,-140},{280,-100}}), iconTransformation(extent={{240,-142},{280,
            -102}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput
                                         yPumWatChi
                    "Pump speed water chiller"
    annotation (Placement(transformation(extent={{240,-260},{280,-220}}),
        iconTransformation(extent={{240,-260},{280,-220}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput
                                         yPumWatHex
    "Pump speed water-side of heat exchanger" annotation (Placement(
        transformation(extent={{240,-220},{280,-180}}), iconTransformation(
          extent={{240,-220},{280,-180}})));

  Controls.OBC.CDL.Integers.LessThreshold allOff(t=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.Normal))
    "Outputs true if all should be off"
    annotation (Placement(transformation(extent={{-100,170},{-80,190}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));
  Controls.OBC.CDL.Integers.GreaterThreshold higDem(t=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.Normal))
    "Outputs true if operated in high demand"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Controls.OBC.CDL.Logical.Sources.Constant fal(k=false) "Outputs false"
    annotation (Placement(transformation(extent={{160,70},{180,90}})));
equation
  connect(demLev, allOff.u)
    annotation (Line(points={{-260,180},{-102,180}}, color={255,127,0}));
  connect(allOff.y, not1.u)
    annotation (Line(points={{-78,180},{-62,180}}, color={255,0,255}));
  connect(not1.y, yWatChi) annotation (Line(points={{-38,180},{100,180},{100,20},
          {260,20}}, color={255,0,255}));
  connect(higDem.u, demLev) annotation (Line(points={{-102,130},{-220,130},{
          -220,180},{-260,180}}, color={255,127,0}));
  connect(yPumWatHex, higDem.y) annotation (Line(points={{260,-200},{80,-200},{
          80,130},{-78,130}}, color={255,0,255}));
  connect(not1.y, yPumWatChi) annotation (Line(points={{-38,180},{100,180},{100,
          -240},{260,-240}}, color={255,0,255}));
  connect(fal.y, yStoByp)
    annotation (Line(points={{182,80},{260,80}}, color={255,0,255}));
  connect(fal.y, yStoOn) annotation (Line(points={{182,80},{200,80},{200,120},{
          260,120}}, color={255,0,255}));
  connect(fal.y, yPumSto) annotation (Line(points={{182,80},{200,80},{200,-80},
          {260,-80}}, color={255,0,255}));
  connect(higDem.y, yPumGlyChi) annotation (Line(points={{-78,130},{80,130},{80,
          -120},{260,-120}}, color={255,0,255}));
  connect(yGlyChi, higDem.y) annotation (Line(points={{260,-20},{80,-20},{80,
          130},{-78,130}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false, extent={{-240,-260},{240,
            240}}),                                                                          graphics={  Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent={{-240,
              240},{240,-260}}),                                                                                                                                                                                       Text(lineColor = {0, 0, 127}, extent={{-50,282},
              {50,238}},                                                                                                                                                                                                        textString = "%name"),
                                                                                                                                                                                                        Text(lineColor={0,0,127},     extent={{-220,
              -122},{2,-320}},
          textString="Efficiency mode")}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent={{-240,-260},{240,
            240}})),
    Documentation(info="<html>
<p>
Plant controller for efficiency mode.
</p>
<p>
Based on the demand level, this controller first runs the water chiller,
and then the glycol chiller.
The storage will be neither charged nor discharged.
</p>
</html>", revisions="<html>
<ul>
<li>
September 21, 2022, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControlEfficiencyMode;
