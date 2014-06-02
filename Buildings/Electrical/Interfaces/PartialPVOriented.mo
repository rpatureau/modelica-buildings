within Buildings.Electrical.Interfaces;
model PartialPVOriented "Partial model of a PV system with orientation"
  extends Buildings.Electrical.Interfaces.PartialPvBase;
  replaceable package PhaseSystem =
      Buildings.Electrical.PhaseSystems.PartialPhaseSystem constrainedby
    Buildings.Electrical.PhaseSystems.PartialPhaseSystem "Phase system"
    annotation (choicesAllMatching=true);
  parameter Modelica.SIunits.Angle til "Surface tilt" annotation(Evaluate=true,Dialog(group="Orientation"));
  parameter Modelica.SIunits.Angle lat "Latitude" annotation(Evaluate=true,Dialog(group="Orientation"));
  parameter Modelica.SIunits.Angle azi "Surface Azimith" annotation(Evaluate=true,Dialog(group="Orientation"));
  replaceable Buildings.Electrical.Interfaces.Terminal terminal(redeclare
      package PhaseSystem = PhaseSystem) "Generalized terminal"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  replaceable PartialPV panel(
    redeclare package PhaseSystem = PhaseSystem,
    redeclare Buildings.Electrical.Interfaces.Terminal terminal(redeclare
        package PhaseSystem =
          PhaseSystem),
    A=A,
    fAct=fAct,
    eta=eta) "PV panel model" annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  BoundaryConditions.SolarIrradiation.DiffusePerez           HDifTil(
    til=til,
    lat=lat,
    azi=azi) "Diffuse irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-66,62},{-46,82}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface           HDirTil(
    til=til,
    lat=lat,
    azi=azi) "Direct irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-66,35},{-46,55}})));
  Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,30})));
  BoundaryConditions.WeatherData.Bus weaBus "Bus with weather data" annotation (
     Placement(transformation(extent={{-10,80},{10,100}}), iconTransformation(
          extent={{-10,80},{10,100}})));
equation
  connect(panel.P, P) annotation (Line(
      points={{11,7},{60,7},{60,70},{110,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(terminal, panel.terminal) annotation (Line(
      points={{-100,0},{-10,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(HDifTil.H,G. u1) annotation (Line(
      points={{-45,72},{-6,72},{-6,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H,G. u2) annotation (Line(
      points={{-45,45},{-30,45},{-30,55},{6,55},{6,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(G.y, panel.G) annotation (Line(
      points={{-1.33227e-15,19},{0,19},{0,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTil.weaBus, weaBus) annotation (Line(
      points={{-66,72},{-90,72},{-90,90},{4.44089e-16,90}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus, HDirTil.weaBus) annotation (Line(
      points={{0,90},{-90,90},{-90,45},{-66,45}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Line(points={{-90,0},{-59,0}}, color={0,0,0}),
        Text(
          extent={{-150,-104},{150,-64}},
          textString="%name",
          lineColor={0,0,255}),
        Polygon(
          points={{-80,-52},{-32,63},{78,63},{29,-52},{-80,-52}},
          smooth=Smooth.None,
          fillColor={205,203,203},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-69,-45},{-57,-19},{-34,-19},{-45,-45},{-69,-45}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-53,-9},{-41,17},{-18,17},{-29,-9},{-53,-9}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-38,27},{-26,53},{-3,53},{-14,27},{-38,27}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-36,-45},{-24,-19},{-1,-19},{-12,-45},{-36,-45}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-20,-9},{-8,17},{15,17},{4,-9},{-20,-9}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-5,27},{7,53},{30,53},{19,27},{-5,27}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-3,-45},{9,-19},{32,-19},{21,-45},{-3,-45}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{13,-9},{25,17},{48,17},{37,-9},{13,-9}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{28,27},{40,53},{63,53},{52,27},{28,27}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{102,107},{124,81}},
          lineColor={0,0,127},
          textString="P")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics),
    Documentation(revisions="<html>
<ul>
<li>
October 31, 2013, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>
Partial model of a simple photovoltaic array.
</p>
<p>
This model takes as an input the information provided by the weather bus: direct and diffuse solar radiation.
The electrical connector is a DC interfaces.
</p>
<p>
This model computes the power as <i>P=A &nbsp; f<sub>act</sub> &nbsp; &eta; &nbsp; G</i>,
where <i>A</i> is the panel area,
<i>f<sub>act</sub></i> is the fraction of the aperture area,
<i>&eta;</i> is the panel efficiency and
<i>G</i> is the total solar irradiation (direct + diffuse). The model takes into account the location and the orientation of the PV panel, specified by the surface tilt, latitude and azimith.
</p>
</html>"));
end PartialPVOriented;
