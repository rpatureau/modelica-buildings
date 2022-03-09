within Buildings.Templates.AirHandlersFans.Components.OutdoorSection;
model NoEconomizer "No Air Economizer"
  extends
    Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.PartialOutdoorSection(
    final typ=Buildings.Templates.AirHandlersFans.Types.OutdoorSection.NoEconomizer,
    final typDamOut=damOut.typ,
    final typDamOutMin=Buildings.Templates.Components.Types.Damper.None);

  Buildings.Templates.Components.Dampers.TwoPosition damOut(
    redeclare final package Medium = MediumAir,
    final dat=dat.damOut)
    "Outdoor air damper"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,0})));
  Buildings.Templates.Components.Sensors.Temperature TAirOut(
    redeclare final package Medium = MediumAir,
    final have_sen=true,
    final m_flow_nominal=m_flow_nominal)
    "Outdoor air temperature sensor"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
equation
  /* Control point connection - start */
  connect(damOut.bus, bus.damOut);
  connect(TAirOut.y, bus.TAirOut);
  /* Control point connection - end */
  connect(port_a, damOut.port_a)
    annotation (Line(points={{-180,0},{-160,0}}, color={0,127,255}));
  connect(damOut.port_b, TAirOut.port_a)
    annotation (Line(points={{-140,0},{-120,0}}, color={0,127,255}));
  connect(TAirOut.port_b, port_b)
    annotation (Line(points={{-100,0},{180,0}}, color={0,127,255}));
  annotation (Icon(graphics={
              Line(
          points={{-180,0},{180,0}},
          color={28,108,200},
          thickness=1)}));
end NoEconomizer;
