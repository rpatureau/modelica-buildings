within Buildings.Fluid.Storage.Plant.Data;
record NominalValues "Nominal values"
  extends Modelica.Icons.Record;

  parameter Boolean allowRemoteCharging
    "Type of plant setup"
    annotation(Dialog(group="Plant configuration"));

  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=
     mTan_flow_nominal+mChi_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(enable=false));
  parameter Modelica.Units.SI.MassFlowRate mTan_flow_nominal(min=0)
    "Nominal mass flow rate for CHW tank branch"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.MassFlowRate mChi_flow_nominal(min=0)
    "Nominal mass flow rate for CHW tank branch"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    final displayUnit="Pa")
    "Nominal pressure difference"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal(
    final displayUnit="degC")=
     7+273.15 "Nominal temperature of CHW supply"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal(
    final displayUnit="degC")=
     12+273.15
    "Nominal temperature of CHW return"
    annotation(Dialog(group="Nominal values"));

  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "nom",
  Documentation(info="<html>
<p>
This is a data record for nominal value declaratations and assignments for
the storage plant model.
It is instantiated in the base class of the branch models
<a href=\"modelica://Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts\">
Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts</a>.
</p>
</html>"));
end NominalValues;