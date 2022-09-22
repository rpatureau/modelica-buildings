within Buildings.Fluid.Storage.Plant;
model NetworkConnection
  "Storage plant section with supply pump and valves"

  extends Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts;

  parameter Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup plaTyp=
    nom.plaTyp
    "Type of plant setup";

  //Pump sizing & interlock
  parameter Buildings.Fluid.Movers.Data.Generic perPumSup
    "Performance data for the supply pump"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})),
    Dialog(group="Pump Sizing and Interlock"));
  parameter Real tPumSupClo=0.01
    "Threshold that pumSup is considered off"
    annotation (Dialog(group="Pump Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Real tPumRetClo=0.01
    "Threshold that pumRet is considered off"
    annotation (Dialog(group="Pump Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));

  //Control valve sizing & interlock
  parameter Modelica.Units.SI.PressureDifference dpValToNetSup_nominal=
    0.1*nom.dp_nominal "Nominal flow rate of intValSup.valToNet"
    annotation (Dialog(group="Control Valve Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Modelica.Units.SI.PressureDifference dpValFroNetSup_nominal=
    0.1*nom.dp_nominal "Nominal flow rate of intValSup.valFroNet"
    annotation (Dialog(group="Control Valve Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Real tValToNetSupClo=0.01
    "Threshold that intValSup.ValToNet is considered closed"
    annotation (Dialog(group="Control Valve Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Real tValFroNetSupClo=0.01
    "Threshold that intValSup.ValFroNet is considered closed"
    annotation (Dialog(group="Control Valve Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Modelica.Units.SI.PressureDifference dpValToNetRet_nominal=
    0.1*nom.dp_nominal "Nominal flow rate of intValRet.valToNet"
    annotation (Dialog(group="Control Valve Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Modelica.Units.SI.PressureDifference dpValFroNetRet_nominal=
    0.1*nom.dp_nominal "Nominal flow rate of intValRet.valFroNet"
    annotation (Dialog(group="Control Valve Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Real tValToNetRetClo=0.01
    "Threshold that intValRet.ValToNet is considered closed"
    annotation (Dialog(group="Control Valve Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));
  parameter Real tValFroNetRetClo=0.01
    "Threshold that intValRet.ValFroNet is considered closed"
    annotation (Dialog(group="Control Valve Sizing and Interlock", enable=
    plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open));

  Buildings.Fluid.Movers.SpeedControlled_y pumSup(
    redeclare final package Medium = Medium,
    final per=perPumSup,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=nom.T_CHWR_nominal) "CHW supply pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,60})));
  Buildings.Fluid.Storage.Plant.BaseClasses.FluidPassThrough pas2(redeclare
      final package Medium = Medium) if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedLocal
    "Replaces conditional components"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Modelica.Blocks.Interfaces.RealInput yValSup[2]
    if plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Positions of the valves on the supply line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={10,130}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,110})));
  Modelica.Blocks.Interfaces.RealInput yPumSup "Speed input of the supply pump"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-10,130}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,110})));

  Buildings.Fluid.Storage.Plant.BaseClasses.InterlockedValves intValSup(
    redeclare final package Medium = Medium,
    final nom=nom,
    final dpValToNet_nominal=dpValToNetSup_nominal,
    final dpValFroNet_nominal=dpValFroNetSup_nominal,
    final tValToNetClo=tValToNetSupClo,
    final tValFroNetClo=tValFroNetSupClo)
    if plaTyp ==
    Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
     or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "A pair of interlocked valves"
    annotation (Placement(transformation(extent={{0,28},{40,68}})));

  Buildings.Fluid.FixedResistances.Junction jun2(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,-nom.mTan_flow_nominal},
    dp_nominal={0,0,0}) if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
     or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Junction" annotation (Placement(transformation(extent={{60,50},{80,70}})));

  FixedResistances.Junction jun1(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,-nom.mTan_flow_nominal},
    dp_nominal={0,0,0}) if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
     or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Junction"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  BaseClasses.FluidPassThrough pas1(redeclare final package Medium = Medium)
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedLocal
    "Replaces conditional components"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
equation
  connect(pas2.port_b, port_bToNet) annotation (Line(points={{60,100},{90,100},
          {90,60},{100,60}}, color={0,127,255}));
  connect(intValSup.yVal, yValSup) annotation (Line(points={{20,70},{20,116},{
          10,116},{10,130}},       color={0,0,127}));
  connect(pumSup.port_b, intValSup.port_aFroChi)
    annotation (Line(points={{-20,60},{0,60}},  color={0,127,255}));
  connect(pumSup.port_b, pas2.port_a) annotation (Line(points={{-20,60},{-10,60},
          {-10,100},{40,100}}, color={0,127,255}));
  connect(jun2.port_1, intValSup.port_bToNet)
    annotation (Line(points={{60,60},{40,60}}, color={0,127,255}));
  connect(jun2.port_2, port_bToNet)
    annotation (Line(points={{80,60},{100,60}}, color={0,127,255}));
  connect(jun2.port_3, intValSup.port_aFroNet)
    annotation (Line(points={{70,50},{70,36},{40,36}}, color={0,127,255}));
  connect(port_bToChi, port_aFroNet)
    annotation (Line(points={{-100,-60},{100,-60}}, color={0,127,255}));
  connect(pumSup.y, yPumSup) annotation (Line(points={{-30,72},{-30,116},{-10,
          116},{-10,130}}, color={0,0,127}));
  connect(port_aFroChi, jun1.port_1)
    annotation (Line(points={{-100,60},{-80,60}}, color={0,127,255}));
  connect(jun1.port_2, pumSup.port_a)
    annotation (Line(points={{-60,60},{-40,60}}, color={0,127,255}));
  connect(jun1.port_3, intValSup.port_bToChi)
    annotation (Line(points={{-70,50},{-70,36},{0,36}}, color={0,127,255}));
  connect(pumSup.port_a, pas1.port_b) annotation (Line(points={{-40,60},{-54,60},
          {-54,100},{-60,100}}, color={0,127,255}));
  connect(port_aFroChi, pas1.port_a) annotation (Line(points={{-100,60},{-86,60},
          {-86,100},{-80,100}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Line(points={{-100,60},{100,60}}, color={28,108,200}),
        Line(points={{-100,-60},{100,-60}}, color={28,108,200}),
        Ellipse(
          extent={{-60,80},{-20,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,60},{24,70},{24,50},{40,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,60},{56,70},{56,50},{40,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Line(
          points={{80,60},{80,32},{-80,32},{-80,60}},
          color={28,108,200},
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,32},{24,42},{24,22},{40,32}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,32},{56,42},{56,22},{40,32}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{-20,60},{-50,76},{-50,44},{-20,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None),
        Ellipse(
          extent={{-60,-40},{-20,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          startAngle=0,
          endAngle=360,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,-60},{24,-50},{24,-70},{40,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,-60},{56,-50},{56,-70},{40,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Line(
          points={{80,-60},{80,-88},{-80,-88},{-80,-60}},
          color={28,108,200},
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,-88},{24,-78},{24,-98},{40,-88}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,-88},{56,-78},{56,-98},{40,-88}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{-20,-60},{-50,-44},{-50,-76},{-20,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open)}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            120}})),
    defaultComponentName = "netCon",
    Documentation(info="<html>
<p>
This model is part of a storage plant model.
It has the following components:
</p>
<table summary= \"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th>Component</th>
    <th>Enabled</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Supply pump<br/>
        <code>pumSup</code></td>
    <td>Always</td>
  </tr>
  <tr>
    <td>Supply output valve<br/>
        <code>intValSup.valToNet</code></td>
    <td rowspan=\"2\"><code>plaTyp == .ClosedRemote</code>
        or <code>.Open</code></td>
  </tr>
  <tr>
    <td>Supply charging valve<br/>
        <code>intValSup.valFroNet</code></td>
  </tr>
  <tr>
    <td>Auxiliary pump<br/>
        <code>pumRet</code></td>
    <td rowspan=\"3\"><code>plaTyp == .Open</code></td>
  </tr>
  <tr>
    <td>Return charging valve<br/>
        <code>intValRet.valToNet</code></td>
  </tr>
  <tr>
    <td>Return output valve<br/>
        <code>intValRet.valFroNet</code></td>
  </tr>
</tbody>
</table>
<p>
Under configurations where remote charging is allowed
(<code>plaTyp == .ClosedRemote</code> or <code>.Open</code>),
these components are controlled by
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.BaseClasses.PumpValveControl\">
Buildings.Fluid.Storage.Plant.BaseClasses.PumpValveControl</a>.
See its documentation for the control objectives.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end NetworkConnection;
