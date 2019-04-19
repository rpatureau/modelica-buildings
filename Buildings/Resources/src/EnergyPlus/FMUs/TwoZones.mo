within ;
model TwoZones "Model of two thermal zones"

  parameter Modelica.SIunits.Time samplePeriod(min=100*Modelica.Constants.eps, start=0.1) = 60
    "Sample period of component";

  parameter output Modelica.SIunits.Volume Core_ZN_V = 3*4*3 "Volume";
  parameter output Modelica.SIunits.Area Core_ZN_AFlo = 3*4 "Floor area";
  parameter output Real Core_ZN_mSenFac = 1 "Factor for scaling sensible thermal mass of volume";
  //parameter Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Core_ZN_T_start = 20
  //  "Initial temperature of zone air";

  parameter output Modelica.SIunits.Volume South_ZN_V = 3*4*3 "Volume";
  parameter output Modelica.SIunits.Area South_ZN_AFlo = 3*4 "Floor area";
  parameter output Real South_ZN_mSenFac = 1 "Factor for scaling sensible thermal mass of volume";
  //parameter Modelica.SIunits.Conversions.NonSIunits.Temperature_degC South_ZN_T_start = 20
  //  "Initial temperature of zone air";

  input Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Core_ZN_T "Temperature of the zone air";
  input Real Core_ZN_X(min=0, final unit="1") "Water vapor mass fraction in kg water/kg dry air";
  input Modelica.SIunits.MassFlowRate Core_ZN_mInlets_flow
     "Sum of positive mass flow rates into the zone for all air inlets (including infiltration)";
  input Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Core_ZN_TAveInlet
    "Average of inlets medium temperatures carried by the mass flow rates";
  input Modelica.SIunits.HeatFlowRate Core_ZN_QGaiRad_flow
    "Radiative sensible heat gain added to the zone";

  input Modelica.SIunits.Conversions.NonSIunits.Temperature_degC South_ZN_T "Temperature of the zone air";
  input Real South_ZN_X(min=0, final unit="1") "Water vapor mass fraction in kg water/kg dry air";
  input Modelica.SIunits.MassFlowRate South_ZN_mInlets_flow
     "Sum of positive mass flow rates into the zone for all air inlets (including infiltration)";
  input Modelica.SIunits.Conversions.NonSIunits.Temperature_degC South_ZN_TAveInlet
    "Average of inlets medium temperatures carried by the mass flow rates";
  input Modelica.SIunits.HeatFlowRate South_ZN_QGaiRad_flow
    "Radiative sensible heat gain added to the zone";

  discrete output Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Core_ZN_TRad
    "Average radiative temperature in the room";
  discrete output Modelica.SIunits.HeatFlowRate Core_ZN_QConSen_flow
    "Convective sensible heat added to the zone";
  discrete output Modelica.SIunits.HeatFlowRate Core_ZN_QLat_flow
    "Latent heat gain added to the zone";
  discrete output Modelica.SIunits.HeatFlowRate Core_ZN_QPeo_flow
      "Heat gain due to people";
  discrete output Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Core_TCon(start=20) "Construction temperature (first order approximation)";

  discrete output Modelica.SIunits.Conversions.NonSIunits.Temperature_degC South_ZN_TRad
    "Average radiative temperature in the room";
  discrete output Modelica.SIunits.HeatFlowRate South_ZN_QConSen_flow
    "Convective sensible heat added to the zone";
  discrete output Modelica.SIunits.HeatFlowRate South_ZN_QLat_flow
    "Latent heat gain added to the zone";
  discrete output Modelica.SIunits.HeatFlowRate South_ZN_QPeo_flow
      "Heat gain due to people";
  discrete output Modelica.SIunits.Conversions.NonSIunits.Temperature_degC South_TCon(start=20) "Construction temperature (first order approximation)";

protected
  parameter Modelica.SIunits.Time startTime(fixed=false) "First sample time instant";
  parameter Modelica.SIunits.Area ACon = (2*6*6+4*6*2.7) "Surface area of constructions";
  parameter Modelica.SIunits.Conductance Ah = ACon * 8 "Conductance A*h for all surfaces";
  parameter Modelica.SIunits.HeatCapacity CCon = ACon*0.2*800*2000 "Heat capacity of constructions";

  output Boolean sampleTrigger "True, if sample time instant";
  output Boolean firstTrigger(start=false, fixed=true)
    "Rising edge signals first sample instant";

initial equation
  startTime = time;

  Core_TCon = 20;
  South_TCon = 20;

equation
  sampleTrigger = sample(startTime, samplePeriod);

  when sampleTrigger then
    firstTrigger = time <= startTime + samplePeriod/2;
  end when;

  when {sampleTrigger} then
    if not initial() then
      Core_TCon = pre(Core_TCon) + samplePeriod / CCon * (Core_ZN_QConSen_flow + Core_ZN_QGaiRad_flow);
      South_TCon = pre(South_TCon) + samplePeriod / CCon * (South_ZN_QConSen_flow + South_ZN_QGaiRad_flow);
    else
      Core_TCon = pre(Core_TCon);
      South_TCon = pre(South_TCon);
    end if;

    Core_ZN_TRad = Core_TCon;
    Core_ZN_QConSen_flow = Ah * (pre(Core_TCon)-Core_ZN_T);
    Core_ZN_QLat_flow = 400;
    Core_ZN_QPeo_flow = 200;

    South_ZN_TRad = South_TCon;
    South_ZN_QConSen_flow = Ah * (pre(South_TCon)-South_ZN_T);
    South_ZN_QLat_flow = 400;
    South_ZN_QPeo_flow = 200;

  end when;

end TwoZones;
