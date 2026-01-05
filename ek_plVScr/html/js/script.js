$(function () {
    function display(bool) {
        if (bool) {
            $("#ui").show();
        } else {
            $("#ui").hide();
        }
    }

    function displayScoreData(bool){
        if (bool) {
            $("#arenadata").show();
        } else {
            $("#arenadata").hide();
        }
    }

    display(false)
    displayScoreData(false)

    window.addEventListener('message', function(event) {
        if (event.data.type === "countdown"){
            let num = event.data.text;	
            if (CD.isPlay == true)
            {
                if (num == "stop")
                {
                    CD.isStop = true;
                    countdown.innerText = "stop";
                    countdown.style.color = "rgb(255,55,55)";
                }
                else
                {
                }		
            }
            else if (Number.isInteger(parseInt(num, 10)))
            {
                CD.anim(num);		
            }
            else
            {	
            }
        }

        var item = event.data;
        if (item.type === "ui") {
            display(item.status)
        }else if(item.type == "fillData"){
            FillContainer(item.data,item.pldata)
        }else if(item.type == "updateQueueData"){
            UpdateQueue(item.arena,item.police,item.criminals)
        }else if(item.type == "score"){
            if (item.action === "updateTimer"){
                $("#timer").html(item.time)
            }else if(item.action === "setLabel"){
                FillScore(item.arena)
            }else if (item.action === "updateKills"){
                if(item.team === "police"){
                    $("#plcounter").html(item.kills)
                    $("#plcounter").addClass("animate__animated animate__flash")
                    setTimeout(function(){
                        $("#plcounter").removeClass("animate__animated animate__flash")
                    },2000)
                }else{
                    $("#crcounter").html(item.kills)
                    $("#crcounter").addClass("animate__animated animate__flash")
                    setTimeout(function(){
                        $("#crcounter").removeClass("animate__animated animate__flash")
                    },2000)
                }
            }else if (item.action === "display"){
                displayScoreData(item.bool)
            }
        }else if (item.type === "UpdateHeaderData"){
            UpdateHeaderData(item.action,item.timer,item.arena)
        }
    });

    document.onkeyup = function (data) {
		if (data.which == 27) {
			display(false)
            Exit()
		}
	};

    $("#ui").on("click", "#close", function() {
        Exit()
    });

    $("#ui").on("click", "#join_police", function() {
        let action
        if ($(this).hasClass("join_police")){
            action = "join"
        }else if ($(this).hasClass("leave_police")){
            action = "leave"
        }
        let arena_data = $(this).attr("arena_data")
        $.post('http://ek_plVScr/chooseTeam', JSON.stringify({
            type:"police",
            arena_data:arena_data,
            action:action
        }))
        Exit()
    });

    $("#ui").on("click", "#join_criminals", function() {
        let action
        if ($(this).hasClass("join_criminals")){
            action = "join"
        }else if ($(this).hasClass("leave_criminals")){
            action = "leave"
        }
        let arena_data = $(this).attr("arena_data")
        $.post('http://ek_plVScr/chooseTeam', JSON.stringify({
            type:"criminals",
            arena_data:arena_data,
            action:action
        }))
        Exit()
    });
});

function FillContainer(data,pldata){
    $("#ui").html("");
    $("#ui").html(
        `<div id="container"></div>
        <div id="close">
            EXIT
        </div>`
    );
    let arena,team
    if (pldata != "nodata"){
        arena = pldata.arena - 1
        team = pldata.team
    }
    for (let a=0;a<data.length;a++){
        let v = data[a]
        $("#container").append(
            `<div id="card" class="card_`+a+`">
                <div id="header">
                    <div id="fight_timer" class="fight_timer`+a+` fight_timer_notstarted">
                        NOT STARTED
                    </div>
                    <div id="label">
                        `+v.label+`
                    </div>
                </div>
                <div id="image">
                    <img src=`+v.image+`>
                </div>
                <div id="slots">
                    <table>
                        <tr>
                            <th style="" class="blue">POLICE</th>
                            <th class="red">CRIMINALS</th>
                        </tr>
                        <tr>
                            <td><span id="police_`+a+`">`+v.police.length+`</span> <span class="blue">/`+v.max_players+`</span></td>
                            <td><span id="criminals_`+a+`">`+v.criminals.length+`</span> <span class="red">/`+v.max_players+`</span></td>
                        </tr>
                    </table>
                </div>
                <div id="join" class="join_`+a+`">
                    <div id="join_police" class="join_police police_location`+a+`" arena_data=`+a+`>
                    <img src="./images/join_police.png">
                    </div>
                    <div id="join_criminals" class="join_criminals criminals_location`+a+`" arena_data=`+a+`>
                    <img src="./images/join_criminals.png">
                    </div>
                </div>
            </div>`
        );
        if (pldata != "nodata"){
            if (arena === a){
                let checkclass = "."+team+"_location"+a
                let previousclass = null
                let newclass = null
                if ($(checkclass).hasClass("join_"+team)){
                    previousclass = "join_"+team
                    newclass = "leave_"+team
                } 
                else {
                    previousclass = "leave_"+team
                    newclass = "join_"+team
                }
                $(checkclass).removeClass(previousclass)
                $(checkclass).addClass(newclass)
                $(checkclass).html(
                    `<img src="./images/`+newclass+`.png">`
                )
            }
        }
    }
}

function UpdateQueue(arena,police,criminals){
    $('#police_'+arena+'').html(police)
    $('#criminals_'+arena+'').html(criminals)
}

function UpdateHeaderData(action,timer,arena){
    let previousclass,newclass,newtext
    let checkclass = '.fight_timer'+arena+''
    if (action === "not_started"){
        newtext = "NOT STARTED"
        previousclass = $(checkclass).attr('class')
        $(checkclass).removeClass("fight_timer_soon")
        $(checkclass).removeClass("fight_timer_started")
        newclass = "fight_timer_notstarted"
    }else if (action === "soon"){
        newtext = "STARTS SOON = "+timer
        $(checkclass).removeClass("fight_timer_notstarted")
        $(checkclass).removeClass("fight_timer_started")
        newclass = "fight_timer_soon"
    }else if (action === "started"){
        newtext = "LIVE = "+timer
        $(checkclass).removeClass("fight_timer_notstarted")
        $(checkclass).removeClass("fight_timer_soon")
        newclass = "fight_timer_started"
    }
    $(checkclass).addClass(newclass)
    $(checkclass).html(newtext)
}

function FillScore(arena){
    $("#arenadata").html("");
    $("#arenadata").html(
        `<div id="data"></div>`
    );
    $("#data").append(
        `<div id="arena">
            `+arena+`
        </div>
        <div id="score">
            <span id="policescore"><span class="scoretext">POLICE</span> <span id="plcounter">0</span></span> &nbsp;
            <span id="VS">VS</span> &nbsp;
            <span id="criminalsscore"><span id="crcounter">0</span> <span class="scoretext">CRIMINALS</span> </span>
        </div>
        <div id="timer">
            00:00
        </div>`
    );
}

function Exit(){
    $.post('http://ek_plVScr/exit', JSON.stringify({}))
    return
}

// COUNTDOWN
var CD = {
	
	isPlay: false,
	isStop: false,
	
	anim: function(n)
	{
		setTimeout(function ()
		{				
			countdown.style.opacity = "1";
			countdown.style.fontSize = "5em";
			
			if (CD.isPlay == false) 
			{
				n++;
				countdown.innerText = n;
				countdown.style.top = "20%";
				countdown.style.color = "rgb(255,255,255)";
				CD.isPlay = true;
			}
			else if(CD.isStop == true)
			{
				countdown.style.top = "5%";
				countdown.style.opacity = "0";
				CD.isPlay = false;
				CD.isStop = false;
				return;
			}

			n--;
			if (n == 0)
			{
				countdown.style.color = "rgb(255,255,55)";

				countdown.innerText = "START!";
				CD.tick("last");

				setTimeout(function (){
					countdown.style.top = "5%";
					countdown.style.opacity = "0";
					CD.isPlay = false;
				}, 1500)
				return;
			}
			else if (n < 10)
			{
				countdown.style.color = "rgb(255,55,255)";
				CD.tick("");
			}
			countdown.innerText = n;			
			setTimeout(function ()
			{
				countdown.style.fontSize = "6em";
				countdown.style.opacity = "0";
				CD.anim(n);
			}, 500);
		},500);
	},
	
	tick: function(type)
	{
		var audio = new Audio();
		if (type == "last")
		{
			audio.src = 'sound/tick.mp3';
		}
		else
		{
			audio.src = 'sound/lastTick.mp3';
		}
		audio.autoplay = true;
	}
};