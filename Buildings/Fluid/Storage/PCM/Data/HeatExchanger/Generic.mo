within Buildings.Fluid.Storage.PCM.Data.HeatExchanger;
record Generic
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Energy TesDesign = 10*3600000 "Design Capacity (factor * 1kWh to J)" annotation(Dialog(group="Sizing"));
  parameter Modelica.Units.SI.Energy TesNominal = PCM.LHea*PCM.d*PCM.x*A_pcm "Nominal Capacity (factor * 1kWh)" annotation(Dialog(group="Sizing"));
  parameter Modelica.Units.SI.DimensionlessRatio TesScale = TesDesign/TesNominal "Scale factor for PCM HX size" annotation(Dialog(group="Sizing"));

  parameter Modelica.Units.SI.Length D = 0.5 "Depth of finned tube heat exchanger"
                                                                                  annotation(Dialog(group="Heat Exchanger"));
  parameter Modelica.Units.SI.Length W = 0.5 "Width of finned tube heat exchanger"
                                                                                  annotation(Dialog(group="Heat Exchanger"));
  parameter Modelica.Units.SI.Length H = TesScale*0.5 "Height of finned tube heat exchanger"
                                                                                            annotation(Dialog(group="Heat Exchanger"));

  parameter Integer Ntubebanks = 6 "Number of tube banks in heat exchanger"
                                                                           annotation(Dialog(group="Tubes"));
  parameter Integer Ntubes_bank = 6 "Number of tubes per bank in heat exchanger"
                                                                                annotation(Dialog(group="Tubes"));
  parameter Integer Ntubes = Ntubebanks*Ntubes_bank "Number of tubes in heat exchanger"
                                                                                       annotation(Dialog(group="Tubes"));
  parameter Integer NPro = integer(Ntubes*(1/2)) "Number of process water tubes in heat exchanger"
                                                                                                  annotation(Dialog(group="Tubes"));
  parameter Integer NDom = integer(Ntubes*(1/2)) "Number of domestic water tubes in heat exchanger"
                                                                                                   annotation(Dialog(group="Tubes"));
  parameter Modelica.Units.SI.Length do = 0.0045 "Outer diameter of tube in heat exchanger"
                                                                                           annotation(Dialog(group="Tubes"));
  parameter Modelica.Units.SI.Length di = 0.0040 "Inner diameter of tube in heat exchanger"
                                                                                           annotation(Dialog(group="Tubes"));
  parameter Modelica.Units.SI.Area A_tubeDom = di*3.14159*NDom*D "Area of tubes in domestic circuit"
                                                                                                    annotation(Dialog(group="Tubes"));
  parameter Modelica.Units.SI.Area A_tubePro = di*3.14159*NPro*D "Area of tubes in process circuit"
                                                                                                   annotation(Dialog(group="Tubes"));

  parameter Modelica.Units.SI.MacroscopicCrossSection Nfins_meter = 500 "Number of fins per meter"
                                                                                                  annotation(Dialog(group="Fins"));
  parameter Integer Nfins = integer(Nfins_meter*D) "Number of fins in heat exchanger"
                                                                                     annotation(Dialog(group="Fins"));
  parameter Modelica.Units.SI.Length t_fin = 0.0001 "Thickness of each fin"
                                                                           annotation(Dialog(group="Fins"));
  parameter Modelica.Units.SI.Length tfins = t_fin*Nfins "Total thickness of all fins"
                                                                                      annotation(Dialog(group="Fins"));
  parameter Modelica.Units.SI.Length sfin = 1/Nfins_meter-t_fin "Spacing between fins"
                                                                                      annotation(Dialog(group="Fins"));
  parameter Modelica.Units.SI.Length xfin = ((H*W)/(di*3.14159*Ntubes)) "Fin heat transfer area per unit length"
                                                                                                                annotation(Dialog(group="Fins"));
  parameter Modelica.Units.SI.Area A_fin = do*3.14159*Ntubes*tfins "Area of fins"
                                                                                 annotation(Dialog(group="Fins"));

  parameter Modelica.Units.SI.MassFlowRate mdotDom = 0.25 "Mass flow rate of working fluid in one domestic water tube bank"
                                                                                                                           annotation(Dialog(group="Convection Correlation"));
  parameter Modelica.Units.SI.MassFlowRate mdotPro = 0.25 "Mass flow rate of working fluid in one process water tube bank"
                                                                                                                          annotation(Dialog(group="Convection Correlation"));
  parameter Modelica.Units.SI.DimensionlessRatio Prw = 7.56 "Prandtl number of working fluid"
                                                                                             annotation(Dialog(group="Convection Correlation"));
  parameter Modelica.Units.SI.ThermalConductivity kw = 0.598 "Thermal conductivity of working fluid"
                                                                                                    annotation(Dialog(group="Convection Correlation"));
  parameter Modelica.Units.SI.DynamicViscosity muw = 8.9e-4 "Dynamic viscosity of working fluid" annotation(Dialog(group="Convection Correlation"));
  parameter Modelica.Units.SI.DimensionlessRatio ReDom = 4*mdotDom/(3.14159*di*muw) "Reynolds number of domestic circuit"
                                                                                                                         annotation(Dialog(group="Convection Correlation"));
  parameter Modelica.Units.SI.DimensionlessRatio RePro = 4*mdotPro/(3.14159*di*muw) "Reynolds number of process circuit"
                                                                                                                        annotation(Dialog(group="Convection Correlation"));

  parameter Modelica.Units.SI.PressureDifference dp1_nominal = TesScale*10000 "Pressure drop in domestic circuit" annotation(Dialog(group="Fluid Flow"));
  parameter Modelica.Units.SI.PressureDifference dp2_nominal = TesScale*10000 "Pressure drop in process circuit" annotation(Dialog(group="Fluid Flow"));

  parameter Modelica.Units.SI.Area A_pcm=(Nfins*2*W*H - 3.14159*(do/2)^2*Ntubes) + do*3.14159*Ntubes*(D-tfins) "Area of pcm"
                                                                                                                            annotation(Dialog(group="PCM"));

  replaceable parameter
    Buildings.HeatTransfer.Data.SolidsPCM.Generic PCM(x=sfin, k= 1.5, c=3150, d=1360, LHea=226000, TSol=273.15 + 55, TLiq=273.15 + 59)  "Sodium acetate trihydrate PCM material record"
                                                                                                                                                                                       annotation(Dialog(group="Materials"));
  replaceable parameter
    Buildings.HeatTransfer.Data.Solids.Generic Aluminum(x=t_fin, k=235, c=904, d=2700) "Aluminum fin material record"
                                                                                                                     annotation(Dialog(group="Materials"));
  replaceable parameter
    Buildings.HeatTransfer.Data.Solids.Generic Copper(x=(do-di), k=400, c=384, d=8960) "Copper tube material record"
                                                                                                                    annotation(Dialog(group="Materials"));
end Generic;