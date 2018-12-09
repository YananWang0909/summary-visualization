<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Online Shopping Review Analysis</title>
<script type="text/javascript" src="js/jquery.js"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<script type='text/javascript' src='js/localdata.js'></script>
<link rel="stylesheet" type="text/css" href="css/main.css" />
<link rel="stylesheet" type="text/css"
	href="css/jquery.autocomplete.css" />
<link rel="stylesheet" type="text/css" href="css/search.css" />
<script type="text/javascript" src="js/echarts.js" charset="UTF-8"></script>
<script type="text/javascript" src="js/theme/dark.js" charset="UTF-8"></script>
<script type="text/javascript" src="js/theme/infographic.js"
	charset="UTF-8"></script>
<script type="text/javascript" src="js/theme/roma.js" charset="UTF-8"></script>
<script src="js/map/china.js"></script>
<script type="text/javascript">
	$().ready(function() {
		$("#main1").hide();
		$("#main2").hide();
		$("#main3").hide();
		$("#searchButton").click(function() {
			var str = $("#suggest1").val();
			postData();
		});

		$("#suggest1").focus().autocomplete(lea, {
			//minCha＝rs: 1,
			width : 703,
			max : 100
		});
		$(":text, textarea").result(log).next().click(function() {
			$(this).prev().search();
		});

	});
</script>
</head>
<body>
</head>
<body>

<h1>Online Shopping Product Review Analysis
	<div>
		<div class="container">
			<div id="search">
				<input type="text" name="q" id="suggest1"
					placeholder="Please enter the product name"> <input
					class="button" type="submit" value="Search" id="searchButton">
			</div>
		</div>
		</h1>
		<div style="margin: 0 5% 0 5%">
			<div id="main1"
				style="width: 100%; height: 800px; margin: 0 0 0 0; border: 0, 0, 0, 0;"></div>
			<div id="main2"
				style="width: 100%; height: 500px; margin: 0 0 0 0; border: 0, 0, 0, 0;"></div>
		
		<div id="main3"
			style="width: 100%; height: Auto; margin: 0 0 0 0; border: 0, 0, 0, 0;"></div>
</div>
		<script type="text/javascript">
			var myChart1 = echarts.init(document.getElementById('main1'));
			var myChart2 = echarts.init(document.getElementById('main2'));

			var option1 = {
				title : {
					text : 'Sentiment Toward Different Features'
				},
				legend : {
					data : [ 'Positive', 'Neutral', 'Negative' ]
				},
				toolbox : {
					show : true,
					feature : {
						mark : {
							show : true
						},
						dataView : {
							show : true,
							readOnly : false
						},
						magicType : {
							show : true,
							type : [ 'line', 'bar', 'stack', 'tiled' ]
						},
						restore : {
							show : true
						},
						saveAsImage : {
							show : true
						}
					}
				},
				calculable : true,
				grid : {
					left : '3%',
					right : '4%',
					bottom : '3%',
					containLabel : true
				},
				xAxis : {
					type : 'value'
				},
				yAxis : {
					type : 'category',
					data : [ "entertainment", "screen", "storage" ]
				},
				series : [ {
					name : 'Positive',
					type : 'bar',
					stack : '总量',
					label : {
						normal : {
							show : true,
							position : 'insideRight'
						}
					},
					data : [ 320, 302, 301 ]
				}, {
					name : 'Neutral',
					type : 'bar',
					stack : '总量',
					label : {
						normal : {

							position : 'insideRight'
						}
					},
					data : [ 120, 132, 101 ]
				}, {
					name : 'Negative',
					type : 'bar',
					stack : '总量',
					label : {
						normal : {

							position : 'insideRight'
						}
					},
					data : [ 220, 182, 191 ]
				}, ]
			};
			myChart1.setOption(option1);

			var option2 = {
				title : {
					text : 'Sentiment Comparision Among Features'
				},
				tooltip : {},
				legend : {
					data : [ 'Positive', 'Neutral', 'Negative' ]
				},
				radar : {
					// shape: 'circle',
					name : {
						textStyle : {
							color : '#fff',
							backgroundColor : '#999',
							borderRadius : 3,
							padding : [ 3, 5 ]
						}
					},
					indicator : [ {
						name : 'A',
						max : 100
					}, {
						name : 'B',
						max : 100
					}, {
						name : 'C',
						max : 100
					}, {
						name : 'D',
						max : 100
					}, {
						name : 'E',
						max : 100
					}, {
						name : 'F',
						max : 100
					} ]
				},
				series : [ {
					type : 'radar',
					// areaStyle: {normal: {}},
					data : [ {
						value : [ 40, 10, 80, 30, 50, 10 ],
						name : 'Positive'
					}, {
						value : [ 20, 40, 20, 30, 20, 20 ],
						name : 'Neutral'
					}, {
						value : [ 40, 50, 0, 40, 30, 70 ],
						name : 'Negative'
					}

					]
				} ]
			};
			myChart2.setOption(option2);

			function postData() {

				$("#main1").show();
				$("#main2").show();
				$("#main3").show();

				// 异步加载数据
				
					$.post('/InformationRetrieval/EchartsServlet?time=' + new Date().getTime(), {
					q : $("#suggest1").val()
				}, function(backdata, status) {
					var object = eval("(" + backdata + ")");

					var obj1 = object.one;
					var obj2 = object.two;
					var obj3 = object.three;
					//myChart.hideLoading();

					// 填入数据
					myChart1.setOption({
						yAxis : {
							type : 'category',
							data : obj1.keywords
						},
						series : [ {
							name : 'Positive',
							type : 'bar',
							stack : '总量',
							label : {
								normal : {
									show : true,
									position : 'insideRight'
								}
							},
							data : obj1.positive
						}, {
							name : 'Neutral',
							type : 'bar',
							stack : '总量',
							label : {
								normal : {

									position : 'insideRight'
								}
							},
							data : obj1.neutral
						}, {
							name : 'Negative',
							type : 'bar',
							stack : '总量',
							label : {
								normal : {

									position : 'insideRight'
								}
							},
							data : obj1.negative
						}, ]
					});

					myChart2.setOption({
						radar : {
							// shape: 'circle',
							name : {
								textStyle : {
									color : 'black',
									backgroundColor : '#999',
									borderRadius : 3,
									padding : [ 3, 5 ]
								}
							},
							indicator : obj2.keywords
						},

						series : [ {
							type : 'radar',
							// areaStyle: {normal: {}},
							data : [ {
								value : obj2.positive,
								name : 'Positive'
							}, {
								value : obj2.neutral,
								name : 'Neutral'
							}, {
								value : obj2.negative,
								name : 'Negative'
							}

							]
						} ]

					});

					var div = document.getElementById("main3"); 
					
					div.innerHTML = '';
					var divTile = document.createElement("label"); 
					divTile.style.fontWeight="bold";
					divTile.style.fontSize="20pt";
					divTile.style.width="100%";
					divTile.innerText ="Negative & Neutral Reviews";  
		            div.append(divTile);
		            var br = document.createElement("br");
		            div.append(br);
					//document.getElementById("resume").innerHTML=resume;
					for (var i = 0; i < obj3.length; i++) {
						
						var sent=obj3[i].sentences;
						
						if(sent.length>0){
							
				            var divBig=document.createElement("div");
				            var div2 = document.createElement("label"); 
				            div2.style.fontWeight="bold";
				            div2.style.fontSize="15pt";
				            div2.style.width="100%";
				            div2.innerText = obj3[i].keyword;  
				            divBig.appendChild(div2);
				            var divsep = document.createElement("div"); 
				            divsep.style.height="10pt";
				            divsep.appendChild(br);
				            divBig.appendChild(divsep);  
				          
							for(var j=0;j<sent.length;j++){
								
								 var input = document.createElement("div");  
								 var index=j+1;
								 
						            input.innerText = index + "		"+sent[j];  
						            divBig.appendChild(input);
						            divBig.appendChild(br);  
							}
							div.appendChild(divBig); 
						}
			            
					}
					

				});
			}
		</script>
</body>
</html>