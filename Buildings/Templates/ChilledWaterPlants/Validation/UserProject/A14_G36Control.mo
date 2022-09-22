within Buildings.Templates.ChilledWaterPlants.Validation.UserProject;
model A14_G36Control
  "Parallel Chillers, Variable Primary Chilled Water, Constant Condenser Water, Headered Pumps with Guideline36 controls"
  extends Buildings.Templates.ChilledWaterPlants.WaterCooled(
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups.CoolingTowerOpen
      cooTowSec(final nCooTow=2),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.ChillerSection.Parallel
      chiSec(final nChi=2, redeclare
        Buildings.Templates.ChilledWaterPlants.Components.PumpsPrimary.HeaderedParallel
        pumPri(final nPum=2, final have_floSen=true)),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.PumpsSecondary.None
      pumSec,
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.PumpsCondenserWater.Headered
      pumCon(final nPum=2),
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.Economizers.None eco,
    redeclare
      Buildings.Templates.ChilledWaterPlants.Components.Controls.Guideline36WaterCooled
      ctr);

  annotation (
    defaultComponentName="chw");
end A14_G36Control;
