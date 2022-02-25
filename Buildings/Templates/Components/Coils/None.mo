within Buildings.Templates.Components.Coils;
model None "No coil"
  extends Buildings.Templates.Components.Coils.Interfaces.PartialCoil(
    final typ=Buildings.Templates.Components.Types.Coil.None,
    final typVal=Buildings.Templates.Components.Types.Valve.None);

equation
  connect(port_a, port_b)
    annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                              Line(
          points={{-100,0},{100,0}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end None;
