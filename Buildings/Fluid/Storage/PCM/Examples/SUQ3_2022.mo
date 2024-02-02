within Buildings.Fluid.Storage.PCM.Examples;
model SUQ3_2022
  "Validating the 11C, 48C, and 58C PCM HXs with single circuit charge / discharge at 3, 6, 9 Lpm and dual circuit charge / discharge at 6, 12, 18 Lpm"
  extends Modelica.Icons.Example;
  replaceable package Medium=Buildings.Media.Water "Water medium";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.2
    "Nominal mass flowrate of Tes";
parameter Modelica.Units.SI.Temperature pcm_Tstart = 311.05;
  Buildings.Fluid.Sources.Boundary_pT sinHPC(redeclare package Medium =
        Medium, nPorts=1) "Flow sink"
    annotation (Placement(transformation(extent={{90,20},{70,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TInHPC(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOutHPC(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T HPCPum(
    use_T_in=true,
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true) "Flow source"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Modelica.Blocks.Sources.CombiTimeTable HPCdata(
    tableOnFile=true,
    tableName="tab1",
    fileName=
        "C:/git/rtu-pcm/modelica-rtu-pcm/RTUPCM/48_dual_6lpm_40C_55C_Run2_all.txt",
    columns={2,4,7},
    timeScale=60)
    annotation (Placement(transformation(extent={{-150,4},{-130,24}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin
    annotation (Placement(transformation(extent={{-116,-8},{-96,12}})));
  Modelica.Blocks.Interfaces.RealOutput TOutHPCMod
    "Modeled outlet fluid temperature"
    annotation (Placement(transformation(extent={{132,50},{152,70}})));
  Modelica.Blocks.Interfaces.RealOutput TOutHPCMea
    "Measured outlet fluid temperature"
    annotation (Placement(transformation(extent={{132,66},{152,86}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin1
    annotation (Placement(transformation(extent={{98,66},{118,86}})));
  Buildings.Fluid.Sensors.DensityTwoPort senDen(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Modelica.Blocks.Math.Gain Lmin_m3s(k=0.001/60)
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Modelica.Blocks.Math.Product m3s_kgs
    annotation (Placement(transformation(extent={{-50,40},{-70,60}})));
  CoilRegisterFourPort pcmFourPort(
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    TStart_pcm=pcm_Tstart,
    Design(TesNominal=3.5*3600000, PCM(
        k=matPro.kPCMLow,
        c=matPro.cPCMLow,
        d=matPro.dPCMLow,
        LHea=matPro.LHeaLow,
        TSol=matPro.TSolLow,
        TLiq=matPro.TLiqLow))) annotation (Placement(transformation(
        extent={{13,13},{-13,-13}},
        rotation=180,
        origin={21,-9})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TInLPC(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{60,-20},{40,-40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOutLPC(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{0,-20},{-20,-40}})));
  Buildings.Fluid.Sources.Boundary_pT sinLPC(redeclare package Medium =
        Medium, nPorts=1) "Flow sink"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Modelica.Blocks.Interfaces.RealOutput TOutLPCMod
    "Modeled outlet fluid temperature"
    annotation (Placement(transformation(extent={{-90,-60},{-110,-40}})));
  Buildings.Fluid.Sources.MassFlowSource_T LPCPum(
    use_T_in=true,
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true) "Flow source"
    annotation (Placement(transformation(extent={{130,-40},{110,-20}})));
  Modelica.Blocks.Sources.CombiTimeTable LPCdata(
    tableOnFile=true,
    tableName="tab1",
    fileName=
        "C:/git/rtu-pcm/modelica-rtu-pcm/RTUPCM/48_dual_6lpm_40C_55C_Run2_all.txt",
    columns={3,6,5},
    timeScale=60)
    annotation (Placement(transformation(extent={{-8,-90},{12,-70}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin2
    annotation (Placement(transformation(extent={{70,-90},{90,-70}})));
  Buildings.Fluid.Sensors.DensityTwoPort senDen1(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{90,-20},{70,-40}})));
  Modelica.Blocks.Math.Gain Lmin_m3s1(k=0.001/60)
    annotation (Placement(transformation(extent={{50,-66},{70,-46}})));
  Modelica.Blocks.Math.Product m3s_kgs1
    annotation (Placement(transformation(extent={{90,-40},{110,-60}})));
  Modelica.Blocks.Interfaces.RealOutput TOutLPCMea
    "Measured outlet fluid temperature"
    annotation (Placement(transformation(extent={{-90,-80},{-110,-60}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin3
    annotation (Placement(transformation(extent={{-58,-80},{-78,-60}})));
  Modelica.Blocks.Interfaces.RealOutput SOC "state of charge"
    annotation (Placement(transformation(extent={{132,-6},{152,14}})));
  Modelica.Blocks.Interfaces.RealOutput QHPC "heat flow from HPC into PCM"
    annotation (Placement(transformation(extent={{132,36},{152,56}})));
  Modelica.Blocks.Interfaces.RealOutput QLPC "heat flow from LPC into PCM"
    annotation (Placement(transformation(extent={{132,22},{152,42}})));
  Modelica.Blocks.Interfaces.RealOutput EPCM
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{132,8},{152,28}})));
  Data.HeatExchanger.MAPR matPro
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));

equation
  connect(toKelvin.Kelvin,HPCPum. T_in)
    annotation (Line(points={{-95,2},{-94,2},{-94,14},{-92,14}},
                                               color={0,0,127}));
  connect(TOutHPC.port_b, sinHPC.ports[1])
    annotation (Line(points={{60,10},{70,10}}, color={0,127,255}));
  connect(HPCdata.y[2], toKelvin.Celsius)
    annotation (Line(points={{-129,14},{-124,14},{-124,2},{-118,2}},
                                                   color={0,0,127}));
  connect(TOutHPC.T, TOutHPCMod)
    annotation (Line(points={{50,21},{50,60},{142,60}}, color={0,0,127}));
  connect(toKelvin1.Kelvin, TOutHPCMea)
    annotation (Line(points={{119,76},{142,76}}, color={0,0,127}));
  connect(HPCdata.y[3], toKelvin1.Celsius) annotation (Line(points={{-129,14},
          {-124,14},{-124,38},{-10,38},{-10,76},{96,76}},
                                                    color={0,0,127}));
  connect(HPCPum.ports[1], senDen.port_a)
    annotation (Line(points={{-70,10},{-50,10}},
                                               color={0,127,255}));
  connect(senDen.port_b, TInHPC.port_a)
    annotation (Line(points={{-30,10},{-20,10}}, color={0,127,255}));
  connect(HPCdata.y[1], Lmin_m3s.u) annotation (Line(points={{-129,14},{-124,14},
          {-124,80},{-112,80}}, color={0,0,127}));
  connect(Lmin_m3s.y, m3s_kgs.u1) annotation (Line(points={{-89,80},{-40,80},{-40,
          56},{-48,56}},      color={0,0,127}));
  connect(senDen.d, m3s_kgs.u2)
    annotation (Line(points={{-40,21},{-40,44},{-48,44}}, color={0,0,127}));
  connect(m3s_kgs.y,HPCPum. m_flow_in) annotation (Line(points={{-71,50},{-98,50},
          {-98,18},{-92,18}},   color={0,0,127}));
  connect(TOutLPC.port_b, sinLPC.ports[1])
    annotation (Line(points={{-20,-30},{-30,-30}}, color={0,127,255}));
  connect(TOutLPC.T, TOutLPCMod) annotation (Line(points={{-10,-41},{-10,-50},{-100,
          -50}}, color={0,0,127}));
  connect(toKelvin2.Kelvin, LPCPum.T_in) annotation (Line(points={{91,-80},{142,
          -80},{142,-26},{132,-26}}, color={0,0,127}));
  connect(LPCPum.ports[1], senDen1.port_a)
    annotation (Line(points={{110,-30},{90,-30}}, color={0,127,255}));
  connect(LPCdata.y[1], Lmin_m3s1.u) annotation (Line(points={{13,-80},{42,-80},
          {42,-56},{48,-56}}, color={0,0,127}));
  connect(Lmin_m3s1.y, m3s_kgs1.u1)
    annotation (Line(points={{71,-56},{88,-56}}, color={0,0,127}));
  connect(senDen1.d, m3s_kgs1.u2)
    annotation (Line(points={{80,-41},{80,-44},{88,-44}}, color={0,0,127}));
  connect(m3s_kgs1.y, LPCPum.m_flow_in) annotation (Line(points={{111,-50},{146,
          -50},{146,-22},{132,-22}}, color={0,0,127}));
  connect(senDen1.port_b, TInLPC.port_a)
    annotation (Line(points={{70,-30},{60,-30}}, color={0,127,255}));
  connect(TOutLPCMea, toKelvin3.Kelvin)
    annotation (Line(points={{-100,-70},{-79,-70}}, color={0,0,127}));
  connect(LPCdata.y[3], toKelvin3.Celsius) annotation (Line(points={{13,-80},
          {42,-80},{42,-62},{-20,-62},{-20,-70},{-56,-70}},
                                                      color={0,0,127}));
  connect(TInHPC.port_b, pcmFourPort.port_a1) annotation (Line(points={{0,10},{
          4,10},{4,-3.54},{8,-3.54}},
                                    color={0,127,255}));
  connect(TOutLPC.port_a, pcmFourPort.port_b2) annotation (Line(points={{0,-30},
          {4,-30},{4,-14.46},{8,-14.46}}, color={0,127,255}));
  connect(TInLPC.port_b, pcmFourPort.port_a2) annotation (Line(points={{40,-30},
          {38,-30},{38,-14.46},{34,-14.46}}, color={0,127,255}));
  connect(TOutHPC.port_a, pcmFourPort.port_b1) annotation (Line(points={{40,10},
          {38,10},{38,-3.54},{34,-3.54}}, color={0,127,255}));
  connect(pcmFourPort.SOC, SOC) annotation (Line(points={{35.3,-20.7},{112,
          -20.7},{112,4},{142,4}},
                             color={0,0,127}));
  connect(pcmFourPort.EPCM, EPCM) annotation (Line(points={{35.3,-17.58},{108,
          -17.58},{108,18},{142,18}}, color={0,0,127}));
  connect(LPCdata.y[2], toKelvin2.Celsius)
    annotation (Line(points={{13,-80},{68,-80}}, color={0,0,127}));
  connect(pcmFourPort.QDom, QHPC) annotation (Line(points={{35.3,2.7},{100,2.7},
          {100,46},{142,46}}, color={0,0,127}));
  connect(pcmFourPort.QPro, QLPC) annotation (Line(points={{35.3,-0.42},{104,-0.42},
          {104,32},{142,32}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -100},{160,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,
            100}})),
    experiment(
      StopTime=8100,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"));
end SUQ3_2022;