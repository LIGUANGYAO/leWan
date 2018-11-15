function drawLayer02Label(canvasObj,text,textBeginX,lineEndX){
	var colorValue = '#04918B';

	var ctx = canvasObj.getContext("2d");

	ctx.beginPath();
	ctx.arc(35,55,2,0,2*Math.PI);
	ctx.closePath();
	ctx.fillStyle = colorValue;
	ctx.fill();

	ctx.moveTo(35,55);
	ctx.lineTo(60,80);
	ctx.lineTo(lineEndX,80);
	ctx.lineWidth = 1;
	ctx.strokeStyle = colorValue;
	ctx.stroke();

	ctx.font='12px Georgia';
	ctx.fillStyle = colorValue;
	ctx.fillText(text,textBeginX,92);
}

//接入机型占比

var COLOR = {
	MACHINE:{
		TYPE_A:'#0175EE',
		TYPE_B:'#D89446',
		TYPE_C:'#373693',
		TYPE_D:'#25AE4F',
		TYPE_E:'#06B5C6',
		TYPE_F:'#009E9A',
		TYPE_G:'#AC266F',
		TYPE_H:'#7347ac',
		TYPE_I:'#ac9882',
		TYPE_J:'#77ac95',
		TYPE_K:'#8792ac',
	}
};



function drawLegend(pointColor,pointY,text){
	var ctx = $("#layer03_left_01 canvas").get(0).getContext("2d");
	ctx.beginPath();
	ctx.arc(20,pointY,10,0,2*Math.PI);
	ctx.fillStyle = pointColor;
	ctx.fill();
	ctx.font='20px';
	ctx.fillStyle = '#FEFFFE';
	ctx.fillText(text,40,pointY+3);
}


//存储
function renderLayer03Right(){
	drawLayer03Right($("#layer03_right_chart01 canvas").get(0),"#027825",0.66);
	drawLayer03Right($("#layer03_right_chart02 canvas").get(0),"#006DD6",0.52);
	drawLayer03Right($("#layer03_right_chart03 canvas").get(0),"#238681",0.34);
}

function drawLayer03Right(canvasObj,colorValue,rate){
	var ctx = canvasObj.getContext("2d");
    
	var circle = {
        x : 65,    //圆心的x轴坐标值
        y : 80,    //圆心的y轴坐标值
        r : 60      //圆的半径
    };

	//画扇形
	//ctx.sector(circle.x,circle.y,circle.r,1.5*Math.PI,(1.5+rate*2)*Math.PI);
	//ctx.fillStyle = colorValue;
	//ctx.fill();

	ctx.beginPath();
	ctx.arc(circle.x,circle.y,circle.r,0,Math.PI*2)
	ctx.lineWidth = 10;
	ctx.strokeStyle = '#052639';
	ctx.stroke();
	ctx.closePath();

	ctx.beginPath();
	ctx.arc(circle.x,circle.y,circle.r,1.5*Math.PI,(1.5+rate*2)*Math.PI)
	ctx.lineWidth = 10;
	ctx.lineCap = 'round';
	ctx.strokeStyle = colorValue;
	ctx.stroke();
	ctx.closePath();
    
	ctx.fillStyle = 'white';
	ctx.font = '20px Calibri';
	ctx.fillText(rate*100+'%',circle.x-15,circle.y+10);

}


function renderChartBar01(){
	var myChart = echarts.init(document.getElementById("layer03_left_02"));
		myChart.setOption(
					 {
						title : {
							text: '',
							subtext: '',
							x:'center'
						},
						tooltip : {
							trigger: 'item',
							formatter: "{b} : {c} ({d}%)"
						},
						legend: {
							show:false,
							x : 'center',
							y : 'bottom',
							data:['A机型','B机型','C机型','D机型','E机型','F机型','G机型']
						},
						toolbox: {
						},
						label:{
							normal:{
								show: true, 
								formatter: "{b} \n{d}%"
							} 
						},
						calculable : true,
						color:[COLOR.MACHINE.TYPE_A,COLOR.MACHINE.TYPE_B,COLOR.MACHINE.TYPE_C,COLOR.MACHINE.TYPE_D,COLOR.MACHINE.TYPE_E,COLOR.MACHINE.TYPE_F,COLOR.MACHINE.TYPE_G],
						series : [
							{
								name:'',
								type:'pie',
								radius : [40, 80],
								center : ['50%', '50%'],
								//roseType : 'area',
								data:[
									{value:4600, name:'A机型'},
									{value:4600, name:'B机型'},
									{value:15600, name:'C机型'},
									{value:6600, name:'D机型'},
									{value:5700, name:'E机型'},
									{value:7600, name:'F机型'},
									{value:3500, name:'G机型'}
								]
							}
						]
					}
		);

}

function pieChart($obj,title,row_tit,colors,$list) {
    var myChart = echarts.init($obj);
    myChart.setOption(
        {
            title : {
                text: title,
                subtext: '',
                x:'center'
            },
            tooltip : {
                trigger: 'item',
                formatter: "{b} : {c} ({d}%)"
            },
            legend: {
                show:false,
                x : 'center',
                y : 'bottom',
                data:row_tit
            },
            toolbox: {
            },
            label:{
                normal:{
                    show: true,
                    formatter: "{b} \n{d}%"
                }
            },
            calculable : true,
            color:colors,
            series : [
                {
                    name:'',
                    type:'pie',
                    radius : [20, 80],
                    center : ['50%', '50%'],
                    //roseType : 'area',
                    data:$list
                }
            ]
        }
    );
}


function diagram($obj,title,row_tit,timetit,$list) {
    var myChart = echarts.init($obj);
    myChart.setOption({
            title: {
                text: title
            },
            tooltip: {
                trigger: 'axis'
            },
            legend: {
                top:20,
                right:5,
                textStyle:{
                    color:'white'
                },
                orient:'vertical',
                data:row_tit
            },
            grid: {
                left: '3%',
                right: '25%',
                bottom: '3%',
                top:'3%',
                containLabel: true
            },
            xAxis: {
                type: 'category',
                boundaryGap: false,
                axisTick:{show:false},
                axisLabel:{
                    textStyle:{
                        color:"white", //刻度颜色
                        fontSize:8  //刻度大小
                    }
                },
                axisLine:{
                    show:true,
                    lineStyle:{
                        color: '#0B3148',
                        width: 1,
                        type: 'solid'
                    }
                },
                data:timetit
            },
            yAxis: {
                type: 'value',
                axisTick:{show:false},
                axisLabel:{
                    textStyle:{
                        color:"white", //刻度颜色
                        fontSize:8  //刻度大小
                    }
                },
                axisLine:{
                    show:true,
                    lineStyle:{
                        color: '#0B3148',
                        width: 1,
                        type: 'solid'
                    }
                },
                splitLine:{
                    show:false
                }
            },
            series: diagramSeries($list),

        }
    );
}


function  diagramSeries($list) {
	var series = [];
		for(var i in $list){
			var $item ={
                name:$list[i].name,
                type:'line',
                itemStyle : {
                    normal : {
                        color:$list[i].color
                    },
                    lineStyle:{
                        normal:{
                            color:$list[i].color,
                            opacity:1
                        }
                    }
                },
                data:$list[i].data
            }
            series.push ($item);
		}
    return series

}

function get10MinutesScale()
{
	var currDate = new Date();
	var odd = currDate.getMinutes()%10;
	var returnArr = new Array();
	currDate.setMinutes(currDate.getMinutes()-odd);
	for(var i = 0; i <7; i++){
		returnArr.push(currDate.getHours()+":"+(currDate.getMinutes()<10?("0"+currDate.getMinutes()):currDate.getMinutes()));
		currDate.setMinutes(currDate.getMinutes()-10);
	}
	return returnArr;
}


function getLatestDays(num)
{
	var currentDay = new Date();
	var returnDays = [];
	for (var i = 0 ; i < num ; i++)
	{
		currentDay.setDate(currentDay.getDate() - 1);
		returnDays.push((currentDay.getMonth()+1)+"/"+currentDay.getDate());
	}
	return returnDays;
}