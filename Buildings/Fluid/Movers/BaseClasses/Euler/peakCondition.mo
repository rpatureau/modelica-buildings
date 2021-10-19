within Buildings.Fluid.Movers.BaseClasses.Euler;
record peakCondition
  "Record for the operation condition at peak efficiency"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.VolumeFlowRate
    V_flow_peak(min=0)
    "Volume flow rate at peak efficiency";
  parameter Modelica.SIunits.PressureDifference
    dp_peak(min=0,displayUnit="Pa")
    "Pressure rise at peak efficiency";
  parameter Modelica.SIunits.Efficiency
    eta_peak
    "Peak efficiency";
  annotation (
Documentation(info="<html>
<p>
Data record for performance data that describe the condition at peak efficiency.
The default values are taken from 
<a href=\"Modelica://Buildings.Fluid.Movers.Data.Pumps.Wilo.CronolineIL80slash220dash4slash4\">
<code>Buildings.Fluid.Movers.Data.Pumps.Wilo.CronolineIL80slash220dash4slash4</code></a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 15, 2021, by Hongxiang Fu:<br/>
First implementation. This is for 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end peakCondition;