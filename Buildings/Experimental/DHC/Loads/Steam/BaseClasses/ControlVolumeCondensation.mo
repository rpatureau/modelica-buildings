﻿within Buildings.Experimental.DHC.Loads.Steam.BaseClasses;
model ControlVolumeCondensation
  "Control volume model exhibiting the condensation process of water"
  extends
    Buildings.Experimental.DHC.BaseClasses.Steam.PartialSaturatedControlVolume;
equation
  // boundary conditions at the ports
  port_a.m_flow = mSte_flow;
  port_a.h_outflow = hSte;
  port_b.m_flow = mWat_flow;
  port_b.h_outflow = hWat;

    connect(portT.y,preTem. T)
      annotation (Line(points={{-69,-50},{-62,-50}},color={0,0,127}));
    connect(heaFloSen.port_b,preTem. port)
      annotation (Line(points={{-30,-50},{-40,-50}},color={191,0,0}));
    connect(heaFloSen.port_a, heatPort)
      annotation (Line(points={{-10,-50},{0,-50},{0,-100}}, color={191,0,0}));

annotation (defaultComponentName="vol",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
      Line(
        points={{38,40},{-2,20},{38,-20},{-2,-40}},
        color={0,0,255},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
      Line(
        points={{-2,40},{-42,20},{-2,-20},{-42,-40}},
        color={0,0,255},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}})}),
    Documentation(revisions="<html>
<ul>
<li>
February 26, 2022 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model represents a condensation process of water with 
liquid and vapor phases in equilibrium and at a saturated state.
Further information regarding the model formulation and assumptions
are in the base class 
<a href=\"modelica://Buildings.Experimental.DHC.BaseClasses.Steam.PartialSaturatedControlVolume\">
Buildings.Experimental.DHC.BaseClasses.Steam.PartialSaturatedControlVolume</a>.

<h4>Reference</h4>
<p>
Hinkelman, Kathryn, Saranya Anbarasu, Michael Wetter, 
Antoine Gautier, and Wangda Zuo. 2022. “A Fast and Accurate Modeling 
Approach for Water and Steam Thermodynamics with Practical 
Applications in District Heating System Simulation.” Preprint. February 24. 
<a href=\"http://dx.doi.org/10.13140/RG.2.2.20710.29762\">doi:10.13140/RG.2.2.20710.29762</a>.
</p>
</html>"));
end ControlVolumeCondensation;
