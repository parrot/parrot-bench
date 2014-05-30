parrot-bench
============

![Curve](parrot-bench-20140321.png)


| RELEASE tags  | seconds       | perf stat -r4 variance |
|---------------|--------------:|:----------------------:|
| RELEASE_1_8_0	| 10.548140110	| (+-1.02%)	|
| RELEASE_1_9_0	|  9.668368740	| (+-0.17%)	|
| RELEASE_2_0_0	|  8.877478111	| (+-0.25%)	|
| RELEASE_2_1_0	|  8.684026868	| (+-0.25%)	|
| RELEASE_2_1_1	|  9.028023147	| (+-4.39%)	|
| RELEASE_2_2_0	|  8.283343194	| (+-0.56%)	|
| RELEASE_2_3_0	|  9.764305233	| (+-2.72%)	|
| RELEASE_2_4_0	|  8.848113139	| (+-0.46%)	|
| RELEASE_2_5_0	|  9.029412536	| (+-2.91%)	|
| RELEASE_2_6_0	|  8.781809000	| (+-0.60%)	|
| RELEASE_2_7_0	|  8.394088549	| (+-4.11%)	|
| RELEASE_2_8_0	|  8.006555133	| (+-0.70%)	|
| RELEASE_2_9_0	| 10.024036191	| (+-0.15%)	|
| RELEASE_2_9_1	|  9.258991772	| (+-0.36%)	|
| RELEASE_2_10_0|  9.301360462	| (+-0.23%)	|
| RELEASE_2_10_1|  9.339934352	| (+-0.32%)	|
| RELEASE_2_11_0|  9.255326252	| (+-0.16%)	|
| RELEASE_3_0_0	|  9.231892740	| (+-0.27%)	|
| RELEASE_3_1_0	| 11.164364145	| (+-1.24%)	|
| RELEASE_3_2_0	| 11.303540437	| (+-0.39%)	|
| RELEASE_3_3_0	| 11.448605784	| (+-0.44%)	|
| RELEASE_3_4_0	| 11.929407362	| (+-0.26%)	|
| RELEASE_3_5_0	| 12.033267815	| (+-0.25%)	|
| RELEASE_3_6_0	| 11.199993453	| (+-0.89%)	|
| RELEASE_3_7_0	| 11.137938747	| (+-0.14%)	|
| RELEASE_3_8_0	| 10.097507754	| (+-0.21%)	|
| RELEASE_3_9_0	| 10.159585045	| (+-0.21%)	|
| RELEASE_3_10_0| 10.323670198	| (+-0.14%)	|
| RELEASE_3_11_0| 10.486785868	| (+-0.19%)	|
| RELEASE_4_0_0	| 10.407319137	| (+-0.19%)	|
| RELEASE_4_1_0	| 10.574911038	| (+-0.44%)	|
| RELEASE_4_2_0	| 10.445002448	| (+-0.15%)	|
| RELEASE_4_3_0	| 10.368422478	| (+-0.35%)	|
| RELEASE_4_4_0	| 10.435474883	| (+-0.37%)	|
| RELEASE_4_5_0	| 10.416064258	| (+-0.14%)	|
| RELEASE_4_6_0	| 10.485801277	| (+-0.17%)	|
| RELEASE_4_7_0	| 10.421811429	| (+-0.25%)	|
| RELEASE_4_8_0	| 10.551825693	| (+-0.08%)	|
| RELEASE_4_9_0	| 10.760177716	| (+-0.21%)	|
| RELEASE_4_10_0| 10.686763273	| (+-0.50%)	|
| RELEASE_4_11_0| 10.705404192	| (+-0.14%)	|
| RELEASE_5_0_0	| 10.639088220	| (+-0.23%)	|
| RELEASE_5_1_0	| 10.654499948	| (+-0.10%)	|
| RELEASE_5_2_0	| 10.692080144	| (+-0.25%)	|
| RELEASE_5_3_0	| 10.639269433	| (+-0.12%)	|
| RELEASE_5_4_0	| 10.663089692	| (+-0.18%)	|
| RELEASE_5_5_0	| 10.627909871	| (+-0.28%)	|
| RELEASE_5_6_0	| 10.661323758	| (+-0.20%)	|
| RELEASE_5_7_0	| 10.691656688	| (+-0.11%)	|
| RELEASE_5_9_0	| 10.672666365	| (+-0.54%)	|
| RELEASE_5_10_0| 10.708653052	| (+-0.14%)	|
| RELEASE_6_0_0	| 10.589940429	| (+-0.51%)	|
| RELEASE_6_1_0	| 10.594964520	| (+-0.25%)	|
| RELEASE_6_2_0	| 10.586717226	| (+-0.32%)	|
| rurban/6model	| 10.505363558	| (+-0.18%)	|
| rurban/pmc2c_orig| 10.585417778 | (+-0.25%)	|
| master	| 10.554795282	| (+-0.37%)	|
| RELEASE_6_3_0	| 10.726002114	| (+-0.22%)	|
| RELEASE_6_4_0	| 10.769352958	| (+-0.23%)	|
| rurban/pmc2c_orig2 | 10.510345097 | (+-0.24%) |

Time in seconds to run all these .pir and .pasm tests without -O.

The tests were selected from `examples/benchmarks`. All which can run
without error on all successfully built parrots.
