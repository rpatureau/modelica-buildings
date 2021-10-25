within Buildings.Templates.Components.Dampers;
model Modulated
  extends Buildings.Templates.Components.Interfaces.Damper(final typ=Types.Damper.Modulated);

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    if loc==Types.Location.OutdoorAir           then
      dat.getReal(varName=id + ".Mechanical.Supply air mass flow rate.value")
    elseif loc==Types.Location.MinimumOutdoorAir            then
      dat.getReal(varName=id + ".Mechanical.Economizer.Minimum outdoor air mass flow rate.value")
    elseif loc==Types.Location.Return           then
      dat.getReal(varName=id + ".Mechanical.Return air mass flow rate.value")
    elseif loc==Types.Location.Relief           then
      dat.getReal(varName=id + ".Mechanical.Return air mass flow rate.value")
    else 0
    "Mass flow rate"
    annotation (Dialog(group="Nominal condition"), Evaluate=true);
  parameter Modelica.SIunits.PressureDifference dpDamper_nominal(
    min=0, displayUnit="Pa")=
    if loc==Types.Location.OutdoorAir           then
      dat.getReal(varName=id + ".Mechanical.Economizer.Outdoor air damper pressure drop.value")
    elseif loc==Types.Location.MinimumOutdoorAir            then
      dat.getReal(varName=id + ".Mechanical.Economizer.Minimum outdoor air damper pressure drop.value")
    elseif loc==Types.Location.Return           then
      dat.getReal(varName=id + ".Mechanical.Economizer.Return air damper pressure drop.value")
    elseif loc==Types.Location.Relief           then
      dat.getReal(varName=id + ".Mechanical.Economizer.Relief air damper pressure drop.value")
    else 0
    "Pressure drop of open damper"
    annotation (Dialog(group="Nominal condition"));

  Fluid.Actuators.Dampers.Exponential damExp(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dpDamper_nominal)
    "Exponential damper"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_a, damExp.port_a) annotation (Line(points={{-100,0},{-56,0},{-56,
          0},{-10,0}}, color={0,127,255}));
  connect(damExp.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(bus.out.y, damExp.y) annotation (Line(
      points={{0.1,100.1},{0.1,56},{0,56},{0,12}},
      color={255,204,51},
      thickness=0.5));
  connect(damExp.y_actual, bus.inp.y_actual) annotation (Line(points={{5,7},{40,
          7},{40,100.1},{0.1,100.1}}, color={0,0,127}));
end Modulated;
