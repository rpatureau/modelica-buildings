within Buildings.ThermalZones.Detailed.Validation.BESTEST;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation(preferredView="info",
  Documentation(info="<html>
<p>
The package <a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.BESTEST\">
Buildings.ThermalZones.Detailed.Validation.BESTEST</a> contains the models
that were used for the BESTEST validation (ANSI/ASHRAE 2020). The basic model from which all other
models extend from is <a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600FF\">
Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600FF</a>.
</p>
<p>
All examples have a script that runs an annual simulation and
plots the results with the minimum, mean and maximum value
listed in the ANSI/ASHRAE Standard 140-2020.
</p>
<p>
The script compares the following quantities:
</p>
<ul>
<li>
For free floating cases, the annual hourly integrated minimum (and maximum)
zone air temperature, and the annual mean zone air temperature.
</li>
<li>
For cases with heating and cooling, the annual heating and cooling energy,
and the annual hourly integrated minimum (and maximum) peak heating and cooling power.
</li>
</ul>
<p>
Note that in addition to the BESTESTs, the window model has been validated separately
in Nouidui et al. (2012).
</p>
<h4>Implementation</h4>
<p>
Heating and cooling is controlled using the PI controller
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.PID\">
Buildings.Controls.OBC.CDL.Continuous.PID</a>
with anti-windup.
</p>
<p>
Hourly averaged values and annual mean values are computed using an instance of
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.MovingAverage\">
Buildings.Controls.OBC.CDL.Continuous.MovingAverage</a>.
</p>
<h4>Validation results</h4>
<p>
The data used for validation are from \"RESULTS5-2A.xlsx\" in folder \"/Sec5-2AFiles/Informative Materials\"
of <a href=\"http://www.ashrae.org/140-2020/\">Supplemental Files for ANSI/ASHRAE Standard 140-2020,
Method of Test for Evaluating Building Performance Simulation Software</a>.
</p>

<h5>Heating and cooling cases</h5>
<p>
The simulations of cases with heating and cooling are validated by comparing the
annual heating and cooling energy, the peak heating and cooling demand with the validation
data. In addition, one day load profiles are also validated.
The detailed comparison, which also shows the peak load hours, are shown
in the table after the plots below.
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/annual_cooling.png\"
     alt=\"annual_cooling.png\" />
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/annual_heating.png\"
     alt=\"annual_heating.png\" />
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/peak_cooling.png\"
     alt=\"peak_cooling.png\" />
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/peak_heating.png\"
     alt=\"peak_heating.png\" />
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/hourly_load_600_Feb1.png\"
     alt=\"hourly_load_600_Jan4.png\" />
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/hourly_load_900_Feb1.png\"
     alt=\"hourly_load_900_Jan4.png\" />
</p>
<!-- table start: load data -->
<table border = \"1\" summary=\"Annual load\">
<tr><td colspan=\"8\"><b>Annual heating load (MWh)</b></td></tr>
<tr>
<th>Case</th>
<th>BSIMAC</th>
<th>CSE</th>
<th>DeST</th>
<th>EnergyPlus</th>
<th>ESP-r</th>
<th>TRNSYS</th>
<th>MBL</th>
</tr><tr>
<td>Case600</td>
<td>4.050</td>
<td>3.993</td>
<td>4.047</td>
<td>4.324</td>
<td>4.362</td>
<td>4.504</td>
<td>4.477</td>
</tr>
<tr>
<td>Case610</td>
<td>4.163</td>
<td>4.066</td>
<td>4.144</td>
<td>4.375</td>
<td>4.527</td>
<td>4.592</td>
<td>4.502</td>
</tr>
<tr>
<td>Case620</td>
<td>4.370</td>
<td>4.094</td>
<td>4.297</td>
<td>4.485</td>
<td>4.514</td>
<td>4.719</td>
<td>4.576</td>
</tr>
<tr>
<td>Case630</td>
<td>4.923</td>
<td>4.356</td>
<td>4.677</td>
<td>4.784</td>
<td>5.051</td>
<td>5.139</td>
<td>4.754</td>
</tr>
<tr>
<td>Case640</td>
<td>2.682</td>
<td>2.403</td>
<td>2.619</td>
<td>2.662</td>
<td>2.654</td>
<td>2.653</td>
<td>2.752</td>
</tr>
<tr>
<td>Case650</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
</tr>
<tr>
<td>Case660</td>
<td>3.574</td>
<td>3.602</td>
<td>3.821</td>
<td>3.707</td>
<td>3.787</td>
<td>3.790</td>
<td>3.621</td>
</tr>
<tr>
<td>Case670</td>
<td>5.484</td>
<td>5.300</td>
<td>5.573</td>
<td>5.616</td>
<td>5.975</td>
<td>6.140</td>
<td>6.515</td>
</tr>
<tr>
<td>Case680</td>
<td>2.219</td>
<td>1.786</td>
<td>1.732</td>
<td>2.180</td>
<td>2.132</td>
<td>2.286</td>
<td>2.241</td>
</tr>
<tr>
<td>Case685</td>
<td>4.532</td>
<td>4.574</td>
<td>4.646</td>
<td>4.877</td>
<td>4.904</td>
<td>5.042</td>
<td>4.962</td>
</tr>
<tr>
<td>Case695</td>
<td>2.709</td>
<td>2.415</td>
<td>2.385</td>
<td>2.802</td>
<td>2.732</td>
<td>2.892</td>
<td>2.781</td>
</tr>
<tr>
<td>Case900</td>
<td>1.726</td>
<td>1.379</td>
<td>1.591</td>
<td>1.664</td>
<td>1.585</td>
<td>1.814</td>
<td>1.699</td>
</tr>
<tr>
<td>Case910</td>
<td>2.163</td>
<td>1.648</td>
<td>1.860</td>
<td>1.956</td>
<td>2.067</td>
<td>2.132</td>
<td>1.867</td>
</tr>
<tr>
<td>Case920</td>
<td>3.500</td>
<td>2.956</td>
<td>3.259</td>
<td>3.337</td>
<td>3.300</td>
<td>3.607</td>
<td>3.310</td>
</tr>
<tr>
<td>Case930</td>
<td>4.270</td>
<td>3.524</td>
<td>3.933</td>
<td>3.994</td>
<td>4.278</td>
<td>4.384</td>
<td>3.731</td>
</tr>
<tr>
<td>Case940</td>
<td>1.389</td>
<td>0.863</td>
<td>1.149</td>
<td>1.067</td>
<td>1.015</td>
<td>1.169</td>
<td>1.197</td>
</tr>
<tr>
<td>Case950</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
<td>0.000</td>
</tr>
<tr>
<td>Case960</td>
<td>0.000</td>
<td>2.522</td>
<td>2.771</td>
<td>2.689</td>
<td>2.624</td>
<td>2.860</td>
<td>2.652</td>
</tr>
<tr>
<td>Case980</td>
<td>0.720</td>
<td>0.246</td>
<td>0.266</td>
<td>0.411</td>
<td>0.351</td>
<td>0.450</td>
<td>0.438</td>
</tr>
<tr>
<td>Case985</td>
<td>2.801</td>
<td>2.120</td>
<td>2.279</td>
<td>2.369</td>
<td>2.283</td>
<td>2.536</td>
<td>2.356</td>
</tr>
<tr>
<td>Case995</td>
<td>1.330</td>
<td>0.755</td>
<td>0.770</td>
<td>1.006</td>
<td>0.905</td>
<td>1.077</td>
<td>0.978</td>
</tr>
<tr><td colspan=\"8\"><b>Annual cooling load (MWh)</b></td></tr>
<tr>
<th>Case</th>
<th>BSIMAC</th>
<th>CSE</th>
<th>DeST</th>
<th>EnergyPlus</th>
<th>ESP-r</th>
<th>TRNSYS</th>
<th>MBL</th>
</tr><tr>
<td>Case600</td>
<td>5.822</td>
<td>5.913</td>
<td>5.432</td>
<td>6.027</td>
<td>6.162</td>
<td>5.780</td>
<td>6.039</td>
</tr>
<tr>
<td>Case610</td>
<td>4.299</td>
<td>4.382</td>
<td>4.173</td>
<td>4.333</td>
<td>4.233</td>
<td>4.117</td>
<td>4.873</td>
</tr>
<tr>
<td>Case620</td>
<td>4.404</td>
<td>4.079</td>
<td>3.909</td>
<td>4.060</td>
<td>4.246</td>
<td>3.841</td>
<td>4.129</td>
</tr>
<tr>
<td>Case630</td>
<td>3.074</td>
<td>3.020</td>
<td>2.787</td>
<td>2.836</td>
<td>2.595</td>
<td>2.573</td>
<td>3.356</td>
</tr>
<tr>
<td>Case640</td>
<td>5.804</td>
<td>5.644</td>
<td>5.237</td>
<td>5.763</td>
<td>5.893</td>
<td>5.477</td>
<td>5.801</td>
</tr>
<tr>
<td>Case650</td>
<td>4.629</td>
<td>4.654</td>
<td>4.186</td>
<td>4.817</td>
<td>4.945</td>
<td>4.632</td>
<td>4.890</td>
</tr>
<tr>
<td>Case660</td>
<td>3.014</td>
<td>3.340</td>
<td>3.260</td>
<td>3.232</td>
<td>3.219</td>
<td>2.966</td>
<td>3.369</td>
</tr>
<tr>
<td>Case670</td>
<td>6.539</td>
<td>6.578</td>
<td>5.954</td>
<td>6.623</td>
<td>6.520</td>
<td>6.198</td>
<td>6.441</td>
</tr>
<tr>
<td>Case680</td>
<td>5.938</td>
<td>6.430</td>
<td>5.932</td>
<td>6.444</td>
<td>6.529</td>
<td>6.310</td>
<td>6.164</td>
</tr>
<tr>
<td>Case685</td>
<td>9.130</td>
<td>8.859</td>
<td>8.238</td>
<td>9.119</td>
<td>9.121</td>
<td>8.851</td>
<td>9.009</td>
</tr>
<tr>
<td>Case695</td>
<td>8.755</td>
<td>8.974</td>
<td>8.386</td>
<td>9.172</td>
<td>9.149</td>
<td>9.039</td>
<td>8.781</td>
</tr>
<tr>
<td>Case900</td>
<td>2.714</td>
<td>2.464</td>
<td>2.383</td>
<td>2.489</td>
<td>2.488</td>
<td>2.267</td>
<td>2.389</td>
</tr>
<tr>
<td>Case910</td>
<td>1.484</td>
<td>1.415</td>
<td>1.490</td>
<td>1.383</td>
<td>1.283</td>
<td>1.191</td>
<td>1.610</td>
</tr>
<tr>
<td>Case920</td>
<td>3.128</td>
<td>2.789</td>
<td>2.706</td>
<td>2.731</td>
<td>2.814</td>
<td>2.549</td>
<td>2.670</td>
</tr>
<tr>
<td>Case930</td>
<td>2.161</td>
<td>2.075</td>
<td>1.908</td>
<td>1.919</td>
<td>1.654</td>
<td>1.672</td>
<td>2.184</td>
</tr>
<tr>
<td>Case940</td>
<td>2.613</td>
<td>2.397</td>
<td>2.343</td>
<td>2.424</td>
<td>2.428</td>
<td>2.203</td>
<td>2.340</td>
</tr>
<tr>
<td>Case950</td>
<td>0.586</td>
<td>0.598</td>
<td>0.618</td>
<td>0.707</td>
<td>0.656</td>
<td>0.642</td>
<td>0.711</td>
</tr>
<tr>
<td>Case960</td>
<td>0.000</td>
<td>0.926</td>
<td>0.909</td>
<td>0.907</td>
<td>0.950</td>
<td>0.789</td>
<td>0.946</td>
</tr>
<tr>
<td>Case980</td>
<td>3.501</td>
<td>3.995</td>
<td>3.758</td>
<td>3.712</td>
<td>3.775</td>
<td>3.519</td>
<td>3.404</td>
</tr>
<tr>
<td>Case985</td>
<td>7.273</td>
<td>6.234</td>
<td>5.880</td>
<td>6.359</td>
<td>6.249</td>
<td>6.113</td>
<td>6.153</td>
</tr>
<tr>
<td>Case995</td>
<td>7.482</td>
<td>7.202</td>
<td>6.771</td>
<td>7.203</td>
<td>7.149</td>
<td>7.064</td>
<td>6.792</td>
</tr>
</table>
<br/>
<table border = \"1\" summary=\"Peak load\">
<tr><td colspan=\"15\"><b>Peak heating load (kW)</b></td></tr>
<tr>
<th rowspan=\"2\">Case</th>
<th colspan=\"2\">BSIMAC</th>
<th colspan=\"2\">CSE</th>
<th colspan=\"2\">DeST</th>
<th colspan=\"2\">EnergyPlus</th>
<th colspan=\"2\">ESP-r</th>
<th colspan=\"2\">TRNSYS</th>
<th colspan=\"2\">MBL</th>
</tr>
<tr>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
</tr><tr>
<td>Case600</td>
<td>3.255</td>
<td>26-Nov:8</td>
<td>3.020</td>
<td>01-Jan:1</td>
<td>3.035</td>
<td>01-Jan:0</td>
<td>3.204</td>
<td>31-Dec:24</td>
<td>3.228</td>
<td>01-Jan:1</td>
<td>3.359</td>
<td>01-Jan:1</td>
<td>3.214</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case610</td>
<td>3.166</td>
<td>26-Nov:8</td>
<td>3.021</td>
<td>01-Jan:1</td>
<td>3.039</td>
<td>01-Jan:0</td>
<td>3.192</td>
<td>31-Dec:24</td>
<td>3.233</td>
<td>01-Jan:1</td>
<td>3.360</td>
<td>01-Jan:1</td>
<td>3.215</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case620</td>
<td>3.145</td>
<td>31-Dec:24</td>
<td>3.038</td>
<td>01-Jan:1</td>
<td>3.068</td>
<td>01-Jan:0</td>
<td>3.229</td>
<td>31-Dec:24</td>
<td>3.253</td>
<td>01-Jan:1</td>
<td>3.385</td>
<td>01-Jan:1</td>
<td>3.239</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case630</td>
<td>3.252</td>
<td>31-Dec:24</td>
<td>3.039</td>
<td>01-Jan:1</td>
<td>3.072</td>
<td>01-Jan:0</td>
<td>3.207</td>
<td>31-Dec:24</td>
<td>3.259</td>
<td>01-Jan:1</td>
<td>3.388</td>
<td>01-Jan:1</td>
<td>3.241</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case640</td>
<td>4.633</td>
<td>08-Feb:9</td>
<td>4.222</td>
<td>26-Nov:8</td>
<td>4.658</td>
<td>26-Nov:7</td>
<td>4.559</td>
<td>26-Nov:8</td>
<td>4.101</td>
<td>26-Nov:8</td>
<td>4.039</td>
<td>26-Nov:8</td>
<td>4.393</td>
<td>26-Nov:8</td>
</tr>
<tr>
<td>Case650</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>01-Jan:1</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>01-Jan:1</td>
<td>0.000</td>
<td>01-Jan:1</td>
<td>0.000</td>
<td>31-Dec:0</td>
<td>0.000</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case660</td>
<td>2.620</td>
<td>26-Nov:8</td>
<td>2.758</td>
<td>01-Jan:1</td>
<td>2.798</td>
<td>01-Jan:0</td>
<td>2.831</td>
<td>31-Dec:24</td>
<td>2.846</td>
<td>01-Jan:1</td>
<td>2.955</td>
<td>01-Jan:1</td>
<td>2.715</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case670</td>
<td>4.122</td>
<td>26-Nov:8</td>
<td>3.655</td>
<td>01-Jan:1</td>
<td>3.812</td>
<td>01-Jan:0</td>
<td>3.854</td>
<td>26-Nov:7</td>
<td>3.992</td>
<td>26-Nov:7</td>
<td>4.221</td>
<td>26-Nov:8</td>
<td>4.302</td>
<td>26-Nov:7</td>
</tr>
<tr>
<td>Case680</td>
<td>2.126</td>
<td>26-Nov:8</td>
<td>1.778</td>
<td>09-Feb:6</td>
<td>1.811</td>
<td>01-Jan:1</td>
<td>2.052</td>
<td>26-Nov:7</td>
<td>2.022</td>
<td>09-Feb:7</td>
<td>2.115</td>
<td>26-Nov:8</td>
<td>2.008</td>
<td>26-Nov:7</td>
</tr>
<tr>
<td>Case685</td>
<td>3.169</td>
<td>26-Nov:8</td>
<td>3.032</td>
<td>01-Jan:1</td>
<td>3.054</td>
<td>01-Jan:0</td>
<td>3.223</td>
<td>31-Dec:24</td>
<td>3.247</td>
<td>01-Jan:1</td>
<td>3.374</td>
<td>01-Jan:1</td>
<td>3.221</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case695</td>
<td>2.138</td>
<td>26-Nov:8</td>
<td>1.795</td>
<td>01-Jan:1</td>
<td>1.855</td>
<td>01-Jan:1</td>
<td>2.072</td>
<td>31-Dec:24</td>
<td>2.025</td>
<td>26-Nov:7</td>
<td>2.118</td>
<td>26-Nov:8</td>
<td>2.045</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case900</td>
<td>2.551</td>
<td>08-Feb:24</td>
<td>2.443</td>
<td>09-Feb:6</td>
<td>2.453</td>
<td>09-Feb:5</td>
<td>2.687</td>
<td>09-Feb:6</td>
<td>2.633</td>
<td>09-Feb:7</td>
<td>2.778</td>
<td>09-Feb:7</td>
<td>2.657</td>
<td>9-Feb:7</td>
</tr>
<tr>
<td>Case910</td>
<td>2.761</td>
<td>08-Feb:24</td>
<td>2.469</td>
<td>09-Feb:6</td>
<td>2.474</td>
<td>09-Feb:5</td>
<td>2.699</td>
<td>09-Feb:6</td>
<td>2.684</td>
<td>09-Feb:7</td>
<td>2.799</td>
<td>09-Feb:6</td>
<td>2.664</td>
<td>9-Feb:7</td>
</tr>
<tr>
<td>Case920</td>
<td>2.895</td>
<td>26-Nov:8</td>
<td>2.512</td>
<td>09-Feb:6</td>
<td>2.513</td>
<td>09-Feb:5</td>
<td>2.770</td>
<td>09-Feb:6</td>
<td>2.706</td>
<td>09-Feb:7</td>
<td>2.864</td>
<td>09-Feb:6</td>
<td>2.735</td>
<td>9-Feb:6</td>
</tr>
<tr>
<td>Case930</td>
<td>2.968</td>
<td>31-Dec:24</td>
<td>2.537</td>
<td>09-Feb:6</td>
<td>2.549</td>
<td>09-Feb:5</td>
<td>2.785</td>
<td>09-Feb:6</td>
<td>2.765</td>
<td>09-Feb:6</td>
<td>2.900</td>
<td>09-Feb:6</td>
<td>2.745</td>
<td>9-Feb:6</td>
</tr>
<tr>
<td>Case940</td>
<td>3.882</td>
<td>08-Feb:9</td>
<td>3.052</td>
<td>01-Jan:9</td>
<td>3.659</td>
<td>09-Feb:7</td>
<td>3.143</td>
<td>31-Dec:9</td>
<td>3.122</td>
<td>09-Feb:9</td>
<td>3.405</td>
<td>01-Jan:9</td>
<td>4.224</td>
<td>9-Feb:8</td>
</tr>
<tr>
<td>Case950</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>01-Jan:1</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>01-Jan:1</td>
<td>0.000</td>
<td>01-Jan:1</td>
<td>0.000</td>
<td>31-Dec:0</td>
<td>0.000</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case960</td>
<td>0.000</td>
<td>N/A</td>
<td>2.132</td>
<td>09-Feb:6</td>
<td>2.085</td>
<td>01-Jan:0</td>
<td>2.259</td>
<td>09-Feb:6</td>
<td>2.201</td>
<td>09-Feb:6</td>
<td>2.300</td>
<td>09-Feb:</td>
<td>2.133</td>
<td>9-Feb:6</td>
</tr>
<tr>
<td>Case980</td>
<td>1.693</td>
<td>08-Feb:24</td>
<td>1.254</td>
<td>09-Feb:6</td>
<td>1.382</td>
<td>09-Feb:5</td>
<td>1.538</td>
<td>09-Feb:6</td>
<td>1.473</td>
<td>09-Feb:7</td>
<td>1.592</td>
<td>09-Feb:7</td>
<td>1.586</td>
<td>1-Jan:1</td>
</tr>
<tr>
<td>Case985</td>
<td>2.754</td>
<td>08-Feb:24</td>
<td>2.452</td>
<td>09-Feb:6</td>
<td>2.458</td>
<td>09-Feb:5</td>
<td>2.695</td>
<td>09-Feb:6</td>
<td>2.642</td>
<td>09-Feb:7</td>
<td>2.785</td>
<td>09-Feb:6</td>
<td>2.654</td>
<td>9-Feb:7</td>
</tr>
<tr>
<td>Case995</td>
<td>1.711</td>
<td>26-Nov:8</td>
<td>1.370</td>
<td>09-Feb:6</td>
<td>1.462</td>
<td>09-Feb:5</td>
<td>1.622</td>
<td>09-Feb:6</td>
<td>1.560</td>
<td>09-Feb:7</td>
<td>1.662</td>
<td>09-Feb:6</td>
<td>1.584</td>
<td>9-Feb:7</td>
</tr>
<tr><td colspan=\"15\"><b>Peak cooling load (kW)</b></td></tr>
<tr>
<th rowspan=\"2\">Case</th>
<th colspan=\"2\">BSIMAC</th>
<th colspan=\"2\">CSE</th>
<th colspan=\"2\">DeST</th>
<th colspan=\"2\">EnergyPlus</th>
<th colspan=\"2\">ESP-r</th>
<th colspan=\"2\">TRNSYS</th>
<th colspan=\"2\">MBL</th>
</tr>
<tr>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
</tr><tr>
<td>Case600</td>
<td>5.650</td>
<td>22-Jan:15</td>
<td>6.481</td>
<td>22-Jan:14</td>
<td>5.422</td>
<td>22-Jan:14</td>
<td>6.352</td>
<td>22-Jan:14</td>
<td>6.193</td>
<td>22-Jan:14</td>
<td>6.046</td>
<td>22-Jan:14</td>
<td>6.247</td>
<td>22-Jan:14</td>
</tr>
<tr>
<td>Case610</td>
<td>5.466</td>
<td>22-Jan:15</td>
<td>6.432</td>
<td>01-Dec:14</td>
<td>5.331</td>
<td>22-Jan:14</td>
<td>6.135</td>
<td>01-Dec:14</td>
<td>5.934</td>
<td>22-Jan:14</td>
<td>5.868</td>
<td>01-Dec:14</td>
<td>6.105</td>
<td>1-Dec:14</td>
</tr>
<tr>
<td>Case620</td>
<td>4.704</td>
<td>26-Jun:18</td>
<td>4.493</td>
<td>26-Jun:17</td>
<td>3.955</td>
<td>26-Jun:17</td>
<td>4.797</td>
<td>26-Jun:17</td>
<td>4.622</td>
<td>26-Jun:17</td>
<td>4.588</td>
<td>26-Jun:17</td>
<td>4.651</td>
<td>26-Jun:17</td>
</tr>
<tr>
<td>Case630</td>
<td>4.121</td>
<td>26-Jun:18</td>
<td>3.998</td>
<td>26-Jun:18</td>
<td>3.526</td>
<td>26-Jun:17</td>
<td>4.212</td>
<td>26-Jun:17</td>
<td>3.971</td>
<td>26-Jun:17</td>
<td>3.949</td>
<td>26-Jun:17</td>
<td>4.184</td>
<td>26-Jun:18</td>
</tr>
<tr>
<td>Case640</td>
<td>5.650</td>
<td>22-Jan:15</td>
<td>6.429</td>
<td>22-Jan:14</td>
<td>5.365</td>
<td>22-Jan:14</td>
<td>6.297</td>
<td>22-Jan:14</td>
<td>6.127</td>
<td>22-Jan:14</td>
<td>5.967</td>
<td>22-Jan:14</td>
<td>6.209</td>
<td>22-Jan:14</td>
</tr>
<tr>
<td>Case650</td>
<td>5.648</td>
<td>22-Jan:15</td>
<td>6.290</td>
<td>01-Dec:14</td>
<td>5.045</td>
<td>18-Oct:14</td>
<td>6.138</td>
<td>18-Oct:14</td>
<td>5.961</td>
<td>18-Oct:14</td>
<td>5.797</td>
<td>18-Oct:14</td>
<td>5.996</td>
<td>1-Dec:14</td>
</tr>
<tr>
<td>Case660</td>
<td>3.343</td>
<td>18-Oct:15</td>
<td>3.933</td>
<td>01-Oct:13</td>
<td>3.355</td>
<td>11-Oct:14</td>
<td>3.770</td>
<td>18-Oct:14</td>
<td>3.530</td>
<td>01-Oct:14</td>
<td>3.457</td>
<td>18-Oct:14</td>
<td>3.654</td>
<td>18-Oct:14</td>
</tr>
<tr>
<td>Case670</td>
<td>6.217</td>
<td>18-Oct:14</td>
<td>6.925</td>
<td>01-Oct:13</td>
<td>5.839</td>
<td>10-Oct:13</td>
<td>6.806</td>
<td>22-Jan:14</td>
<td>6.482</td>
<td>18-Oct:14</td>
<td>6.401</td>
<td>18-Oct:14</td>
<td>6.620</td>
<td>22-Jan:14</td>
</tr>
<tr>
<td>Case680</td>
<td>5.761</td>
<td>22-Jan:15</td>
<td>7.051</td>
<td>22-Jan:14</td>
<td>5.861</td>
<td>22-Jan:14</td>
<td>6.770</td>
<td>22-Jan:14</td>
<td>6.676</td>
<td>22-Jan:14</td>
<td>6.557</td>
<td>22-Jan:14</td>
<td>6.556</td>
<td>22-Jan:14</td>
</tr>
<tr>
<td>Case685</td>
<td>6.318</td>
<td>22-Jan:15</td>
<td>7.159</td>
<td>22-Jan:14</td>
<td>6.071</td>
<td>22-Jan:14</td>
<td>7.107</td>
<td>22-Jan:14</td>
<td>6.934</td>
<td>22-Jan:14</td>
<td>6.867</td>
<td>22-Jan:14</td>
<td>6.982</td>
<td>22-Jan:14</td>
</tr>
<tr>
<td>Case695</td>
<td>6.232</td>
<td>22-Jan:15</td>
<td>7.541</td>
<td>22-Jan:14</td>
<td>6.355</td>
<td>22-Jan:14</td>
<td>7.334</td>
<td>22-Jan:14</td>
<td>7.239</td>
<td>22-Jan:14</td>
<td>7.175</td>
<td>22-Jan:14</td>
<td>7.110</td>
<td>22-Jan:14</td>
</tr>
<tr>
<td>Case900</td>
<td>3.039</td>
<td>01-Oct:15</td>
<td>3.376</td>
<td>01-Oct:14</td>
<td>2.556</td>
<td>11-Sep:14</td>
<td>3.040</td>
<td>01-Oct:14</td>
<td>2.896</td>
<td>12-Oct:15</td>
<td>2.940</td>
<td>01-Oct:14</td>
<td>2.964</td>
<td>1-Oct:15</td>
</tr>
<tr>
<td>Case910</td>
<td>2.493</td>
<td>18-Oct:14</td>
<td>2.722</td>
<td>02-Oct:15</td>
<td>2.103</td>
<td>12-Oct:14</td>
<td>2.222</td>
<td>18-Oct:15</td>
<td>2.212</td>
<td>02-Oct:15</td>
<td>2.081</td>
<td>12-Oct:15</td>
<td>2.284</td>
<td>1-Oct:15</td>
</tr>
<tr>
<td>Case920</td>
<td>3.481</td>
<td>26-Jun:18</td>
<td>3.057</td>
<td>26-Jun:18</td>
<td>2.710</td>
<td>26-Jun:17</td>
<td>3.260</td>
<td>26-Jun:18</td>
<td>3.099</td>
<td>26-Jun:18</td>
<td>3.154</td>
<td>26-Jun:18</td>
<td>3.182</td>
<td>26-Jun:18</td>
</tr>
<tr>
<td>Case930</td>
<td>3.052</td>
<td>26-Jun:18</td>
<td>2.662</td>
<td>26-Jun:18</td>
<td>2.335</td>
<td>26-Jun:17</td>
<td>2.782</td>
<td>26-Jun:18</td>
<td>2.494</td>
<td>26-Jun:18</td>
<td>2.613</td>
<td>26-Jun:18</td>
<td>2.808</td>
<td>26-Jun:18</td>
</tr>
<tr>
<td>Case940</td>
<td>3.158</td>
<td>01-Oct:15</td>
<td>3.376</td>
<td>01-Oct:14</td>
<td>2.556</td>
<td>11-Sep:14</td>
<td>3.040</td>
<td>01-Oct:14</td>
<td>2.891</td>
<td>12-Oct:15</td>
<td>2.938</td>
<td>01-Oct:14</td>
<td>2.964</td>
<td>1-Oct:15</td>
</tr>
<tr>
<td>Case950</td>
<td>2.366</td>
<td>10-Sep:15</td>
<td>2.364</td>
<td>04-Sep:15</td>
<td>2.054</td>
<td>11-Sep:14</td>
<td>2.388</td>
<td>11-Sep:15</td>
<td>2.202</td>
<td>10-Sep:15</td>
<td>2.236</td>
<td>11-Sep:15</td>
<td>2.341</td>
<td>11-Sep:15</td>
</tr>
<tr>
<td>Case960</td>
<td>0.000</td>
<td>N/A</td>
<td>1.377</td>
<td>26-Jun:17</td>
<td>1.367</td>
<td>26-Jun:16</td>
<td>1.480</td>
<td>26-Jun:17</td>
<td>1.403</td>
<td>26-Jun:17</td>
<td>1.338</td>
<td>26-Jun:17</td>
<td>1.463</td>
<td>26-Jun:17</td>
</tr>
<tr>
<td>Case980</td>
<td>3.384</td>
<td>18-Oct:14</td>
<td>3.668</td>
<td>02-Oct:14</td>
<td>2.930</td>
<td>18-Oct:14</td>
<td>3.450</td>
<td>18-Oct:15</td>
<td>3.341</td>
<td>12-Oct:15</td>
<td>3.313</td>
<td>12-Oct:14</td>
<td>3.278</td>
<td>18-Oct:15</td>
</tr>
<tr>
<td>Case985</td>
<td>3.977</td>
<td>18-Oct:14</td>
<td>4.225</td>
<td>01-Oct:14</td>
<td>3.208</td>
<td>11-Oct:14</td>
<td>3.915</td>
<td>18-Oct:15</td>
<td>3.736</td>
<td>12-Oct:15</td>
<td>3.885</td>
<td>01-Oct:14</td>
<td>3.834</td>
<td>1-Oct:15</td>
</tr>
<tr>
<td>Case995</td>
<td>4.129</td>
<td>22-Jan:14</td>
<td>4.224</td>
<td>22-Jan:15</td>
<td>3.315</td>
<td>22-Jan:14</td>
<td>4.177</td>
<td>22-Jan:15</td>
<td>3.954</td>
<td>22-Jan:15</td>
<td>4.115</td>
<td>22-Jan:15</td>
<td>3.950</td>
<td>22-Jan:15</td>
</tr>
</table>
<br/>
<!-- table end: load data -->

<h5>Free floating cases</h5>
<p>
The following plots compare the maximum, minimum and average zone temperature simulated with
the Modelica Buildings Library with the values simulated by other tools. The simulation
is also validated by comparing one-day simulation results in different days, and by
comparing the distribution of the annual temperature. The detailed comparisons, which also
show the peak temperature hour, are shown in the table after the plots.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/max_temperature.png\"
     alt=\"max_temperature.png\" />
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/min_temperature.png\"
     alt=\"min_temperature.png\" />
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/FF_temperature_600FF_Feb1.png\"
     alt=\"FF_temperature_600FF_Feb1.png\" />
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/FF_temperature_900FF_Feb1.png\"
     alt=\"FF_temperature_900FF_Feb1.png\" />
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/FF_temperature_650FF_Jul14.png\"
     alt=\"FF_temperature_650FF_Jul14.png\" />
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/FF_temperature_950FF_Jul14.png\"
     alt=\"FF_temperature_950FF_Jul14.png\" />
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/ave_temperature.png\"
     alt=\"ave_temperature.png\" />
<img src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Validation/BESTEST/bin_temperature_900FF.png\"
     alt=\"bin_temperature_900FF.png\" />
</p>

<!-- table start: free float data -->
<table border = \"1\" summary=\"Peak temperature\">
<tr><td colspan=\"15\"><b>Maximum temperature (&deg;C)</b></td></tr>
<tr>
<th rowspan=\"2\">Case</th>
<th colspan=\"2\">BSIMAC</th>
<th colspan=\"2\">CSE</th>
<th colspan=\"2\">DeST</th>
<th colspan=\"2\">EnergyPlus</th>
<th colspan=\"2\">ESP-r</th>
<th colspan=\"2\">TRNSYS</th>
<th colspan=\"2\">MBL</th>
</tr>
<tr>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
</tr><tr>
<td>Case600FF</td>
<td>63.4</td>
<td>18-Oct:17</td>
<td>68.4</td>
<td>01-Oct:16</td>
<td>65.0</td>
<td>11-Oct:15</td>
<td>63.8</td>
<td>18-Oct:16</td>
<td>64.6</td>
<td>01-Oct:16</td>
<td>62.4</td>
<td>01-Oct:15</td>
<td>63.6</td>
<td>18-Oct:16</td>
</tr>
<tr>
<td>Case650FF</td>
<td>62.1</td>
<td>18-Oct:17</td>
<td>66.8</td>
<td>01-Oct:16</td>
<td>62.6</td>
<td>11-Oct:15</td>
<td>62.5</td>
<td>18-Oct:16</td>
<td>63.3</td>
<td>01-Oct:16</td>
<td>61.1</td>
<td>01-Oct:15</td>
<td>62.5</td>
<td>18-Oct:16</td>
</tr>
<tr>
<td>Case680FF</td>
<td>72.5</td>
<td>22-Jan:17</td>
<td>78.5</td>
<td>22-Jan:16</td>
<td>75.0</td>
<td>12-Oct:15</td>
<td>70.1</td>
<td>22-Jan:16</td>
<td>72.2</td>
<td>12-Oct:16</td>
<td>69.8</td>
<td>22-Jan:16</td>
<td>69.1</td>
<td>22-Jan:16</td>
</tr>
<tr>
<td>Case900FF</td>
<td>46.0</td>
<td>01-Oct:17</td>
<td>45.1</td>
<td>04-Sep:15</td>
<td>44.5</td>
<td>11-Sep:15</td>
<td>44.3</td>
<td>12-Sep:15</td>
<td>44.3</td>
<td>12-Sep:16</td>
<td>43.3</td>
<td>12-Sep:15</td>
<td>43.7</td>
<td>12-Sep:16</td>
</tr>
<tr>
<td>Case950FF</td>
<td>37.1</td>
<td>01-Oct:17</td>
<td>36.8</td>
<td>11-Sep:15</td>
<td>36.4</td>
<td>11-Sep:15</td>
<td>36.7</td>
<td>11-Sep:16</td>
<td>36.4</td>
<td>05-Aug:16</td>
<td>36.1</td>
<td>11-Sep:16</td>
<td>36.6</td>
<td>11-Sep:16</td>
</tr>
<tr>
<td>Case960</td>
<td>0.000</td>
<td>N/A</td>
<td>48.9</td>
<td>02-Oct:16</td>
<td>53.2</td>
<td>20-Oct:14</td>
<td>49.9</td>
<td>12-Oct:15</td>
<td>49.5</td>
<td>12-Oct:15</td>
<td>48.1</td>
<td>12-Oct:15</td>
<td>47.9</td>
<td>12-Oct:16</td>
</tr>
<tr>
<td>Case980FF</td>
<td>49.7</td>
<td>01-Oct:17</td>
<td>52.2</td>
<td>12-Sep:15</td>
<td>52.8</td>
<td>21-Oct:14</td>
<td>49.6</td>
<td>12-Sep:16</td>
<td>50.2</td>
<td>12-Sep:15</td>
<td>48.5</td>
<td>12-Sep:15</td>
<td>48.4</td>
<td>12-Sep:16</td>
</tr>
<tr><td colspan=\"15\"><b>Minimum temperature (&deg;C)</b></td></tr>
<tr>
<th rowspan=\"2\">Case</th>
<th colspan=\"2\">BSIMAC</th>
<th colspan=\"2\">CSE</th>
<th colspan=\"2\">DeST</th>
<th colspan=\"2\">EnergyPlus</th>
<th colspan=\"2\">ESP-r</th>
<th colspan=\"2\">TRNSYS</th>
<th colspan=\"2\">MBL</th>
</tr>
<tr>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
</tr><tr>
<td>Case600FF</td>
<td>-9.9</td>
<td>26-Nov:8</td>
<td>-12.9</td>
<td>09-Feb:7</td>
<td>-13.5</td>
<td>09-Feb:6</td>
<td>-12.6</td>
<td>09-Feb:7</td>
<td>-13.5</td>
<td>09-Feb:7</td>
<td>-13.8</td>
<td>09-Feb:7</td>
<td>-12.9</td>
<td>9-Feb:7</td>
</tr>
<tr>
<td>Case650FF</td>
<td>-16.7</td>
<td>31-Dec:24</td>
<td>-17.8</td>
<td>01-Jan:1</td>
<td>-17.4</td>
<td>30-Dec:23</td>
<td>-17.1</td>
<td>31-Dec:24</td>
<td>-17.5</td>
<td>01-Jan:1</td>
<td>-17.5</td>
<td>31-Dec:24</td>
<td>-16.8</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case680FF</td>
<td>-5.7</td>
<td>08-Feb:11</td>
<td>-6.2</td>
<td>09-Feb:7</td>
<td>-6.9</td>
<td>09-Feb:7</td>
<td>-7.1</td>
<td>09-Feb:7</td>
<td>-7.2</td>
<td>09-Feb:7</td>
<td>-8.1</td>
<td>09-Feb:7</td>
<td>-7.3</td>
<td>9-Feb:7</td>
</tr>
<tr>
<td>Case900FF</td>
<td>0.6</td>
<td>08-Feb:11</td>
<td>2.2</td>
<td>09-Feb:7</td>
<td>1.3</td>
<td>09-Feb:7</td>
<td>1.2</td>
<td>09-Feb:7</td>
<td>1.6</td>
<td>09-Feb:7</td>
<td>0.6</td>
<td>09-Feb:7</td>
<td>1.2</td>
<td>9-Feb:7</td>
</tr>
<tr>
<td>Case950FF</td>
<td>-13.2</td>
<td>31-Dec:24</td>
<td>-13.2</td>
<td>01-Jan:1</td>
<td>-13.4</td>
<td>30-Dec:23</td>
<td>-12.8</td>
<td>09-Feb:7</td>
<td>-12.5</td>
<td>09-Feb:6</td>
<td>-12.8</td>
<td>09-Feb:6</td>
<td>-11.8</td>
<td>9-Feb:6</td>
</tr>
<tr>
<td>Case960</td>
<td>0.000</td>
<td>N/A</td>
<td>8.0</td>
<td>09-Feb:8</td>
<td>6.7</td>
<td>09-Feb:6</td>
<td>5.1</td>
<td>09-Feb:7</td>
<td>5.0</td>
<td>09-Feb:7</td>
<td>4.2</td>
<td>09-Feb:7</td>
<td>4.0</td>
<td>9-Feb:7</td>
</tr>
<tr>
<td>Case980FF</td>
<td>7.3</td>
<td>08-Feb:11</td>
<td>12.5</td>
<td>04-Nov:7</td>
<td>12.4</td>
<td>05-Nov:6</td>
<td>9.9</td>
<td>04-Nov:7</td>
<td>10.5</td>
<td>04-Nov:8</td>
<td>9.5</td>
<td>04-Nov:7</td>
<td>9.7</td>
<td>4-Nov:8</td>
</tr>
</table>
<br/>
<!-- table end: free float data -->
<h4>Implementation</h4>
<p>
To generate the data shown in this user guide, run
</p>
<pre>
  cd Buildings/Resources/src/ThermalZones/Detailed/Validation/BESTEST
  python3 simulateAndPlot.py
</pre>
<h4>References</h4>
<p>
ANSI/ASHRAE. 2007. ANSI/ASHRAE Standard 140-2007,
Standard Method of Test for the Evaluation of Building Energy Analysis Computer Programs.
</p>
<p>
Thierry Stephane Nouidui, Michael Wetter, and Wangda Zuo.
<a href=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/2012-simBuild-windowValidation.pdf\">
Validation of the window model of the Modelica Buildings library.</a>
<i>Proc. of the 5th SimBuild Conference</i>, Madison, WI, USA, August 2012.
</p>
</html>"));
end UsersGuide;
