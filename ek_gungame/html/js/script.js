// KILLFEED
let kills = [];
var $killFeedContainer = null;
var $killFeedElement = null;

const fakeNames = [];
var isInPedMenu = false; 
var pedMenu_gungameData

function display(bool) {
    if (bool) {
        $("#gungame").show();
    } else {
        $("#gungame").hide();
    }
}
function displayIngameLdb(bool) {
    if (bool) {
        $("#gungame-ingame-leaderboard").fadeIn();
        $("#gungame-stats").show();
        $("#q-exit").show();
        $("#weapon-details").show();
    } else {
        $("#gungame-ingame-leaderboard").fadeOut();
        $("#gungame-stats").hide();
        $("#q-exit").hide();
        $("#weapon-details").hide();
    }
}
function displayPedMenu(bool,peds,kills,gungameData) {
    if (bool) {
        isInPedMenu = true
        PedSelector(peds,kills,gungameData)
        $("#gungame-pedselector").fadeIn();
    } else {
        isInPedMenu = false
        $("#gungame-pedselector").fadeOut();
    }
}
function displayWinner(bool,gungameData, sourceData, winnerData) {
    if (bool) {
        displayIngameLdb(false)
        WinnerUI(gungameData, sourceData, winnerData)
        $("#gungame-winner").fadeIn();
    } else {
        $("#gungame-winner").fadeOut();
    }
}
function displayGeneralLDB(bool,gungameData) {
    if (bool) {
        GeneralLDB(gungameData)
        $("#onetap-leaderboard").fadeIn();
    } else {
        $("#onetap-leaderboard").fadeOut();
    }
}

$(function () {

    // KILL FEED
    $killFeedContainer = $(".kill-feed");
    $killFeedElement = $(".kill-feed > div").hide();

    display(false)
    displayIngameLdb(false)
    displayPedMenu(false)
    displayWinner(false)
    displayGeneralLDB(false)

    window.addEventListener('message', function(event) {
        var item = event.data;

        if (item.type === "countdown"){
            let num = item.text;	
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

        if (item.type === "kill") {
            let killer = item.killer
            if (killer === "")
              killer = fakeNames[Math.floor(Math.random() * fakeNames.length)];
            let victim = item.victim
            if (victim === "")
              victim = fakeNames[Math.floor(Math.random() * fakeNames.length)];
            const weapon = item.weapon;
            addKill(killer, victim, weapon,item.headshot);
        }

        if (item.type == "sounds"){
            SoundCheck(item.action)
        }

        if (item.type == "weapon"){
            if (item.action == 'image'){
                $('#weapon-details-img').css('background',`url(images/weapons/` + item.weapon + `.png) center center no-repeat`)
            }else if (item.action == 'ammo'){
                $('#weapon-details-ammo-info').html(item.ammo)

            }
        }

        if (item.type === "key-buttons"){
            if (item.toggle){
                $('#q-exit div').html(
                    `
                        [Q] <i class="fas fa-long-arrow-alt-right"></i> EXIT <br>
                        [${item.label}] <i class="fas fa-long-arrow-alt-right"></i> LEADERBOARD
                    `
                )
            }else{
                $('#q-exit div').html("")
            }
        }

        if (item.type == 'generalLdb'){
            displayGeneralLDB(item.bool, item.gungameData)
        }

        if (item.type === "ui"){
            display(item.display)
        }

        if (item.type === "gungame"){
            if (item.action == "ui"){
                display(item.display)
            }else if(item.action == "fillUI"){
                fillUI(item.fill,item.data)
            }else if(item.action == "updateUI"){
                if (item.update == "map"){
                    $(".gungame-box-"+item.gungame+" #gungame-wrapper-box-header").html(item.html)
                    $(".gungame-box-"+item.gungame+" .gungame-activeMapSize").html(item.size)
                }else if(item.update == "players"){
                    $(".gungame-box-"+item.gungame+" .gungame-activePlayers").html("")
                    $(".gungame-box-"+item.gungame+" .gungame-activePlayers").html(item.html)
                }
            }
        }

        if (item.type === "hud-stats"){
            updateHudStats(item.stats)
        }

        if (item.type === 'ingame-leadeboard'){
            if (item.action == "build"){
                ConstructIngameLeaderboard(item.gungameData,item.playerData)
            }else if(item.action == "updateTop3"){
                updateTop3(item.top3)
            }else if (item.action == "updateStats"){
                updateIngameLdbStats(item.playerData)
            }
            else if(item.action == "hide"){
                displayIngameLdb(false)
            }
        }

        if (item.type == "pedselector"){
            displayPedMenu(item.bool, item.peds,item.kills,item.gungameData)
        }

        if (item.type == "winnerUI"){
            displayWinner(item.bool,item.gungameData,item.sourceData, item.winnerData)
        }
        
    });

    document.onkeyup = function (data) {
        if (data.which == 27 && !isInPedMenu) {
            Exit()
            return
		}
	};

    $("#gungame").on("click", "#gungame-wrapper-box-buttons-join", function() {
        var $gungame = $(this).attr('gungame')
        $.post('http://ek_gungame/joinGungame', JSON.stringify({
            gungame:$gungame
        }))
        Exit()
    });
});

function Exit(){
    $.post('http://ek_gungame/exit', JSON.stringify({}))
    return
}

function LeaveGungame(){
    displayWinner(false)
    $.post('http://ek_gungame/leaveGungame', JSON.stringify({}))
    return
}

function Topshooters(){
    $.post('http://ek_gungame/displayTop10', JSON.stringify({}))
    return
}

function Matches(){
    $.post('http://ek_gungame/displayMatches', JSON.stringify({}))
    return
}

function Winners(){
    $.post('http://ek_gungame/displayWinners', JSON.stringify({}))
    return
}

function fillUI(action,data){
    $("#gungame-wrapper").html("");
    $("#gungame-buttons-topshooters").removeClass('gungame-selected-button-topshooters')
    $("#gungame-buttons-matches").removeClass('gungame-selected-button-matches')
    $("#gungame-buttons-winners").removeClass('gungame-selected-button-winners')
    if (action === "matches"){
        $("#gungame-wrapper").html(
            `<div id="gungame-wrapper-matches"></div>`
        );
        $("#gungame-buttons-matches").addClass('gungame-selected-button-matches')
        $.each(data, function(key,value){
            if (value == null){
                return
            }
            $("#gungame-wrapper-matches").append(
                `<div id="gungame-wrapper-box" class="animate__animated animate__backInDown gungame-box-${key+1}">
                    <div id="gungame-wrapper-box-header">
                        ${value.map.label}
                    </div>
                    <div id="gungame-wrapper-box-info">
                        <div id="gungame-wrapper-box-info-map" class="gungame-wrapper-box-info-child">
                            <div id="gungame-wrapper-box-info-type-title">
                                MAP <i class="far fa-map"></i>
                            </div>
                            <div id="gungame-wrapper-box-info-type-desc" class="gungame-activeMapSize">
                                ${value.map.size}
                            </div>
                        </div>
                        <div id="gungame-wrapper-box-box-info" class="gungame-wrapper-box-info-child">
                            <div id="gungame-wrapper-box-info-type-title">
                                PLAYERS <i class="far fa-user"></i>
                            </div>
                            <div id="gungame-wrapper-box-info-type-desc" class="players">
                                <span class="gungame-activePlayers">${value.players.length}</span><span class="gungame-maxPlayers">/${value.maxPlayers}</span>
                            </div>
                        </div>
                    </div>
                    <div id="gungame-wrapper-box-buttons">
                        <div id="gungame-wrapper-box-buttons-join" gungame="${key + 1}">
                            JOIN
                        </div>
                    </div>
                </div>`
            )
        })
    }else if (action === "top10"){
        $("#gungame-wrapper").html(
            `<div id="gungame-wrapper-topshooters">
                <table>
                    <tr class="gungame-wrapper-topshooters-header">
                        <td class="td-20">No.</td>
                        <td class="td-40">Name</td>
                        <td class="td-20">Kills</td>
                        <td class="td-20">Deaths</td>
                        <td class="td-20">KDR</td>
                    </tr>
                </table>
            </div>`
        );
        $("#gungame-buttons-topshooters").addClass('gungame-selected-button-topshooters')
        $.each(data, function(key,value){
            if (value == null){
                return
            }
            var kdr = value.gungamekills/value.gungamedeaths
            if(isNaN(kdr) || kdr==Infinity){
                kdr = "-"
            }
            if (kdr>=0 && kdr!=Infinity){}
            else{
                kdr = "-"
            }
            if (!isInt(kdr) && kdr != '-'){
                kdr = parseFloat(kdr).toFixed(2)
            }
            let element = ''
            if (key === 0){
                element = `<tr class="first"><td class="td-20"><i class="fas fa-trophy"></i>1</td><td class="td-40"> ${value.name} </td><td class="td-20">${value.gungamekills}</td><td class="td-20">${value.gungamedeaths}</td><td class="td-20">${kdr}</td></tr>`
            }
            else if (key === 1){
                element = `<tr class="second"><td class="td-20"><i class="fas fa-trophy"></i>2</td><td class="td-40"> ${value.name} </td><td class="td-20">${value.gungamekills}</td><td class="td-20">${value.gungamedeaths}</td><td class="td-20">${kdr}</td></tr>`
            }
            else if (key === 2){
                element = `<tr class="third"><td class="td-20"><i class="fas fa-trophy"></i>3</td><td class="td-40"> ${value.name} </td><td class="td-20">${value.gungamekills}</td><td class="td-20">${value.gungamedeaths}</td><td class="td-20">${kdr}</td></tr>`
            }
            else if (key > 2 && key < 10){
                element = `<tr><td class="td-20">${key + 1}</td><td class="td-40"> ${value.name} </td><td class="td-20">${value.gungamekills}</td><td class="td-20">${value.gungamedeaths}</td><td class="td-20">${kdr}</td></tr>`
            }
            $("#gungame-wrapper-topshooters table").append(element)
            if (key === 9){
                return;
            }
        })
        if(data.length < 10){
            for (i = data.length; i <= 10; i++) {
                $("#gungame-wrapper-topshooters table").append(
                    `<tr><td class="td-20">${i}</td><td class="td-40"> - </td><td class="td-20">-</td><td class="td-20">-</td><td class="td-20">-</td></tr>`
                )
            }
        }
    }else if (action === "winners"){
        $("#gungame-wrapper").html(
            `<div id="gungame-wrapper-winners">
                <table>
                    <tr class="gungame-wrapper-winners-header">
                        <td class="td-20">No.</td>
                        <td class="td-40">Name</td>
                        <td class="td-20">Wins</td>
                    </tr>
                </table>
            </div>`
        );
        $("#gungame-buttons-winners").addClass('gungame-selected-button-winners')
        $.each(data, function(key,value){
            if (value == null){
                return
            }
            var kdr = value.gungamekills/value.gungamedeaths
            if(isNaN(kdr) || kdr==Infinity){
                kdr = "-"
            }
            if (kdr>=0 && kdr!=Infinity){}
            else{
                kdr = "-"
            }
            if (!isInt(kdr) && kdr != '-'){
                kdr = parseFloat(kdr).toFixed(2)
            }
            let element = ''
            if (key === 0){
                element = `<tr class="first"><td class="td-20"><i class="fas fa-trophy"></i>1</td><td class="td-40"> ${value.name} </td><td class="td-20">${value.gungamewins}</td></tr>`
            }
            else if (key === 1){
                element = `<tr class="second"><td class="td-20"><i class="fas fa-trophy"></i>2</td><td class="td-40"> ${value.name} </td><td class="td-20">${value.gungamewins}</td></tr>`
            }
            else if (key === 2){
                element = `<tr class="third"><td class="td-20"><i class="fas fa-trophy"></i>3</td><td class="td-40"> ${value.name} </td><td class="td-20">${value.gungamewins}</td></tr>`
            }
            else if (key > 2 && key < 10){
                element = `<tr><td class="td-20">${key + 1}</td><td class="td-40"> ${value.name} </td><td class="td-20">${value.gungamewins}</td></tr>`
            }
            $("#gungame-wrapper-winners table").append(element)
            if (key === 9){
                return;
            }
        })
        if(data.length < 10){
            for (i = data.length + 1; i <= 10; i++) {
                $("#gungame-wrapper-winners table").append(
                    `<tr><td class="td-20">${i}</td><td class="td-40"> - </td><td class="td-20">-</td></tr>`
                )
            }
        }
    }
}

function isInt(n) {
    return n % 1 === 0;
}

function updateHudStats(stats){
    var kdr = stats.kills/stats.deaths
    if(isNaN(kdr)){
        kdr = 0
    }
    if (kdr>=0 && kdr!=Infinity){}
    else{
        kdr = "-"
    }
    if (!isInt(kdr)){
        kdr = parseFloat(kdr).toFixed(2)
    }
    $("#gungame-stats-kills span").html(stats.kills)
    $("#gungame-stats-deaths span").html(stats.deaths)
    $("#gungame-stats-kdr span").html(kdr)
}

function ConstructIngameLeaderboard(gungameData,playerData){
    updateTop3(gungameData.top3)
    updateIngameLdbStats(playerData)
    displayIngameLdb(true)
}

function updateTop3(top3){
    $.each(top3, function(key,value){
        if (value == null){
            return
        }
        if (key == 0){
            $(".ingame-leaderboard-first .ingame-leaderboard-leftSide").html(
                `
                <img src="images/gold.png"> ${value.name}
                `
            )
            $(".ingame-leaderboard-first .ingame-leaderboard-rightSide").html(value.level)
        }else if(key == 1){
            $(".ingame-leaderboard-second .ingame-leaderboard-leftSide").html(
                `
                <img src="images/silver.png"> ${value.name}
                `
            )
            $(".ingame-leaderboard-second .ingame-leaderboard-rightSide").html(value.level)
        }else{
            $(".ingame-leaderboard-third .ingame-leaderboard-leftSide").html(
                `
                <img src="images/bronze.png"> ${value.name}
                `
            )
            $(".ingame-leaderboard-third .ingame-leaderboard-rightSide").html(value.level)
        }
    })
}

function updateIngameLdbStats(playerData){
    $.each(playerData, function(key,value){
        if (value == null){
            return
        }
        if (key == "level"){
            $(".ingame-leaderboard-"+key+" .ingame-leaderboard-rightSide").html(value+"/9")
            return
        }
        $(".ingame-leaderboard-"+key+" .ingame-leaderboard-rightSide").html(value)
    })
    // KILLS LEFT TO LEVEL UP
    let killstarget = playerData.loadout[playerData.level].kills
    $(".ingame-leaderboard-killsleft .ingame-leaderboard-rightSide").html(killstarget - playerData.levelkills)

    // KDR 
    var kdr = playerData.roundkills/playerData.rounddeaths
    if(isNaN(kdr) || kdr==Infinity){
        kdr = "-"
    }
    if (kdr>=0 && kdr!=Infinity){}
    else{
        kdr = "-"
    }
    if (!isInt(kdr) && kdr != '-'){
        kdr = parseFloat(kdr).toFixed(2)
    }
    $(".ingame-leaderboard-kdr .ingame-leaderboard-rightSide").html(kdr)
}

function PedSelector(peds, playerKills, gungameData){
    $("#peds").html("")
    pedMenu_gungameData = gungameData
    
    $.each(peds, function(key,value){
        if (value == null){
            return
        }
        if (playerKills >= value.kills){
            $("#peds").append(
                `<div onclick="changePed('${value.spawn}')" class="ped_selection">
                    <div id="ped_selection-image">
                        <img src="images/peds/${value.image}.png" id="ped_selection-imagePed" >
                    </div>
                    <div id="ped_selection-text">
                        <i class="fas fa-user"> </i>
                        <span id="text"> USE PED</span>
                    </div>
                </div>`
            )
        }else{
            $("#peds").append(
                `<div class="ped_selection">
                    <div id="ped_selection-image">
                        <img src="images/locked.png" class="ped_selection-locked"> 
                        <img src="images/peds/${value.image}.png" id="ped_selection-imagePed" class="ped_selection-imagePed-locked">
                    </div>
                    <div id="ped_selection-text">
                        <i class="fas fa-user"> </i>
                        <span id="text"> YOU NEED ${value.kills - playerKills} KILLS</span>
                    </div>
                </div>`
            )
        }
    })
}

function changePed(ped){
    $.post('http://ek_gungame/changePed', JSON.stringify({
        ped:ped,
        gungameData:pedMenu_gungameData
    }));
}

function WinnerUI(gungameData,sourceData, winnerData){
    $("#gungame-winner").html(
        `<div id="gungame-winner-main">
            <div id="gungame-winner-label">
                GUNGAME STATS <br>
            </div>
            <div id="gungame-winner-exit" onclick="LeaveGungame()">
                EXIT GUNGAME
            </div>
            <div id="gungame-winner-newround">
                <div id="gungame-winner-newround-text">
                    New round soon...
                </div>
                <div id="gungame-winner-newround-loading">
                    <div id="gungame-winner-newround-progressBar"></div> 
                </div>
            </div>
            <div id="gungame-winner-main-leaderboard">
                <div id="gungame-winner-main-leaderboard-first" class="gungame-winner-main-leaderboard-place">
                    <div id="gungame-winner-main-leaderboard-image">
                        <img src="images/gold.png"></img>
                    </div>
                    <div class="medal-name name-first">
                        None
                    </div>
                    <div class="gungame-winner-main-leaderboard-level level-first">
                        -
                    </div>
                </div>
                <div id="gungame-winner-main-leaderboard-second" class="gungame-winner-main-leaderboard-place">
                    <div id="gungame-winner-main-leaderboard-image">
                        <img src="images/silver.png"></img>
                    </div>
                    <div class="medal-name name-second">
                        None
                    </div>
                    <div class="gungame-winner-main-leaderboard-level level-second">
                        -
                    </div>
                </div>
                <div id="gungame-winner-main-leaderboard-third" class="gungame-winner-main-leaderboard-place">
                    <div id="gungame-winner-main-leaderboard-image">
                        <img src="images/bronze.png"></img>
                    </div>
                    <div class="medal-name name-third">
                        None
                    </div>
                    <div class="gungame-winner-main-leaderboard-level level-third">
                        -
                    </div>
                </div>
            </div>
            <div id="gungame-winner-main-box">
                <div id="gungame-winner-main-box-winner">
                    <div id="gungame-winner-main-box-header">
                        WINNER 
                    </div>
                    <div id="gungame-winner-main-box-name" class="gungame-winner-main-box-stats">
                        Name <i class="fas fa-long-arrow-alt-right"></i> <span>Ektoras</span>
                    </div>
                    <div id="gungame-winner-main-box-kills" class="gungame-winner-main-box-stats">
                        Kills <i class="fas fa-long-arrow-alt-right"></i> <span>27</span>
                    </div>
                    <div id="gungame-winner-main-box-deaths" class="gungame-winner-main-box-stats">
                        Deaths <i class="fas fa-long-arrow-alt-right"></i>  <span>27</span>
                    </div>
                    <div id="gungame-winner-main-box-kdr" class="gungame-winner-main-box-stats">
                        KDR <i class="fas fa-long-arrow-alt-right"></i> <span>1</span>
                    </div>
                    <div id="gungame-winner-main-box-wins" class="gungame-winner-main-box-stats">
                        WINS <i class="fas fa-long-arrow-alt-right"></i> <span>1</span>
                    </div>
                </div>
                <div id="gungame-winner-main-box-player">
                    <div id="gungame-winner-main-box-header">
                        PLACED  #2
                    </div>
                    <div id="gungame-winner-main-box-name" class="gungame-winner-main-box-stats">
                        Name <i class="fas fa-long-arrow-alt-right"></i> <span>LNIKOP</span>
                    </div>
                    <div id="gungame-winner-main-box-kills" class="gungame-winner-main-box-stats">
                        Kills <i class="fas fa-long-arrow-alt-right"></i> <span>5</span>
                    </div>
                    <div id="gungame-winner-main-box-deaths" class="gungame-winner-main-box-stats">
                        Deaths <i class="fas fa-long-arrow-alt-right"></i>  <span>2</span>
                    </div>
                    <div id="gungame-winner-main-box-kdr" class="gungame-winner-main-box-stats">
                        KDR <i class="fas fa-long-arrow-alt-right"></i> <span>2.5</span>
                    </div>
                    <div id="gungame-winner-main-box-wins" class="gungame-winner-main-box-stats">
                        WINS <i class="fas fa-long-arrow-alt-right"></i> <span>1</span>
                    </div>
                </div>
            </div>
        </div>`
    )

    $.each(gungameData.top3, function(key,value){
        if (value == null){
            return
        }
        if (key == 0){
            $(".name-first").html(value.name)
            $(".level-first").html(value.level)
        }else if(key == 1){
            $(".name-second").html(value.name)
            $(".level-second").html(value.level)
        }else{
            $(".name-third").html(value.name)
            $(".level-third").html(value.level)
        }
    })
    
    // WINNER BOX  
    var kdr = winnerData.roundkills/winnerData.rounddeaths
    if(isNaN(kdr) || kdr==Infinity){
        kdr = "-"
    }
    if (kdr>=0 && kdr!=Infinity){}
    else{
        kdr = "-"
    }
    if (!isInt(kdr) && kdr != '-'){
        kdr = parseFloat(kdr).toFixed(2)
    }
    $("#gungame-winner-main-box-winner #gungame-winner-main-box-name span").html(winnerData.name)
    $("#gungame-winner-main-box-winner #gungame-winner-main-box-kills span").html(winnerData.roundkills)
    $("#gungame-winner-main-box-winner #gungame-winner-main-box-deaths span").html(winnerData.rounddeaths)
    $("#gungame-winner-main-box-winner #gungame-winner-main-box-kdr span").html(kdr)
    $("#gungame-winner-main-box-winner #gungame-winner-main-box-wins span").html(winnerData.wins)

    // SOURCE PLAYER BOX
    var kdr = sourceData.roundkills/sourceData.rounddeaths
    if(isNaN(kdr)){
        kdr = 0
    }
    if (kdr>=0 && kdr!=Infinity){}
    else{
        kdr = "-"
    }
    if (!isInt(kdr)){
        kdr = parseFloat(kdr).toFixed(2)
    }
    $("#gungame-winner-main-box-player #gungame-winner-main-box-header").html("PLACED #"+sourceData.place)
    $("#gungame-winner-main-box-player #gungame-winner-main-box-name span").html(sourceData.name)
    $("#gungame-winner-main-box-player #gungame-winner-main-box-kills span").html(sourceData.roundkills)
    $("#gungame-winner-main-box-player #gungame-winner-main-box-deaths span").html(sourceData.rounddeaths)
    $("#gungame-winner-main-box-player #gungame-winner-main-box-kdr span").html(kdr)
    $("#gungame-winner-main-box-player #gungame-winner-main-box-wins span").html(sourceData.wins)

    const progress_bars = document.querySelectorAll('#gungame-winner-newround-progressBar');
    progress_bars.forEach(bar => {
        const { size } = bar.dataset;
        bar.style.width = `0%`;
    });
    var loading_timer = 0; 
    var interval = setInterval(function() { 
        if (loading_timer < 10) { 
            loading_timer++;
            progress_bars.forEach(bar => {
                const { size } = bar.dataset;
                bar.style.width = ``+(loading_timer/10)*100+`%`;
            });
        }
        else { 
            $.post('http://ek_gungame/nui_startNewRound', JSON.stringify({}));
            displayWinner(false)
            clearInterval(interval);
        }
     }, 1000);
}

function GeneralLDB(gungameData){
    if (gungameData.length > 24){
        $("#onetap-leaderboard").html(
            `<div id="onetap-leaderboard-label">
                <i class="fas fa-level-down-alt"></i> ROUND LIVE LEADERBOARD <i class="fas fa-level-up-alt"></i>
            </div>
            <div id="onetap-leaderboard-wrapper" class="left-side-onetap-leaderboard-wrapper">
                <div id="onetap-leaderboard-wrapper-header">
                    <div id="onetap-leaderboard-wrapper-">PLAYER</div>
                    <div id="onetap-leaderboard-wrapper-">LEVEL</div>
                    <div id="onetap-leaderboard-wrapper-">KILLS</div>
                    <div id="onetap-leaderboard-wrapper-">DEATHS</div>
                    <div id="onetap-leaderboard-wrapper-">KD RATIO</div>
                </div>
                <div id="onetap-leaderboard-wrapper-table"></div>
            </div>
            <div id="onetap-leaderboard-wrapper" class="right-side-onetap-leaderboard-wrapper">
                <div id="onetap-leaderboard-wrapper-header">
                    <div id="onetap-leaderboard-wrapper-">PLAYER</div>
                    <div id="onetap-leaderboard-wrapper-">LEVEL</div>
                    <div id="onetap-leaderboard-wrapper-">KILLS</div>
                    <div id="onetap-leaderboard-wrapper-">DEATHS</div>
                    <div id="onetap-leaderboard-wrapper-">KD RATIO</div>
                </div>
                <div id="onetap-leaderboard-wrapper-table"></div>
            </div>
            `
        )
        $.each(gungameData, function(key,value){
            if (value == null){
                return
            }
            var kdr = value.roundkills/value.rounddeaths
            if(isNaN(kdr) || kdr==Infinity){
                kdr = "-"
            }
            if (kdr>=0 && kdr!=Infinity){}
            else{
                kdr = "-"
            }
            if (!isInt(kdr) && kdr != '-'){
                kdr = parseFloat(kdr).toFixed(2)
            }
            let element = `
                <div id="onetap-leaderboard-wrapper-table-row">
                    <div id="onetap-leaderboard-wrapper-table-row-player">${value.name}</div>
                    <div id="onetap-leaderboard-wrapper-table-row-level">${value.level}</div>
                    <div id="onetap-leaderboard-wrapper-table-row-kills">${value.roundkills}</div>
                    <div id="onetap-leaderboard-wrapper-table-row-deaths">${value.rounddeaths}</div>
                    <div id="onetap-leaderboard-wrapper-table-row-kdr">${kdr}</div>
                </div>
            `
            if (key < 25){
                $(".left-side-onetap-leaderboard-wrapper #onetap-leaderboard-wrapper-table").append(element)
            }else{
                $(".right-side-onetap-leaderboard-wrapper #onetap-leaderboard-wrapper-table").append(element)
            }
        })
    }else{
        $("#onetap-leaderboard").html(
            `<div id="onetap-leaderboard-label">
                <i class="fas fa-level-down-alt"></i> ROUND LIVE LEADERBOARD <i class="fas fa-level-up-alt"></i>
            </div>
            <div id="onetap-leaderboard-wrapper">
                <div id="onetap-leaderboard-wrapper-header">
                    <div id="onetap-leaderboard-wrapper-">PLAYER</div>
                    <div id="onetap-leaderboard-wrapper-">LEVEL</div>
                    <div id="onetap-leaderboard-wrapper-">KILLS</div>
                    <div id="onetap-leaderboard-wrapper-">DEATHS</div>
                    <div id="onetap-leaderboard-wrapper-">KD RATIO</div>
                </div>
                <div id="onetap-leaderboard-wrapper-table"></div>
            </div>
            `
        )
        $.each(gungameData, function(key,value){
            if (value == null){
                return
            }
            var kdr = value.roundkills/value.rounddeaths
            if(isNaN(kdr) || kdr==Infinity){
                kdr = "-"
            }
            if (kdr>=0 && kdr!=Infinity){}
            else{
                kdr = "-"
            }
            if (!isInt(kdr) && kdr != '-'){
                kdr = parseFloat(kdr).toFixed(2)
            }
            let element = `
                <div id="onetap-leaderboard-wrapper-table-row">
                    <div id="onetap-leaderboard-wrapper-table-row-player">${value.name}</div>
                    <div id="onetap-leaderboard-wrapper-table-row-level">${value.level}</div>
                    <div id="onetap-leaderboard-wrapper-table-row-kills">${value.roundkills}</div>
                    <div id="onetap-leaderboard-wrapper-table-row-deaths">${value.rounddeaths}</div>
                    <div id="onetap-leaderboard-wrapper-table-row-kdr">${kdr}</div>
                </div>
            `
            $("#onetap-leaderboard-wrapper-table").append(element)
        })
    }
}

function SoundCheck(action){
    let sounds
    switch (action) {
        case "doublekill":
            text = "DOUBLEKILL"
            sound = "./sounds/double_kill.ogg";
            break;
        case "triplekill":
            text = "TRIPLEKILL"
            sound = "./sounds/triple_kill.ogg";
            break;
        case "killingspree":
            text = "KILLING SPREE"
            sound = "./sounds/killing_spree.ogg";
            break;
        case "megakill":
            text = "MEGA KILL"
            sound = "./sounds/mega_kill.ogg";
            break;
        case "ultrakill":
            text = "ULTRA KILL"
            sound = "./sounds/ultra_kill.ogg";
            break;
        case "ownage":
            text = "OWNAGE"
            sound = "./sounds/ownage.ogg";
            break;
        case "dominating":
            text = "DOMINATING"
            sound = "./sounds/dominating.ogg";
            break;
        case "wickedsick":
            text = "WICKED SICK"
            sound = "./sounds/wicked_sick.ogg";
            break;
        case "monsterkill":
            text = "MMMMONSTER KILL"
            sound = "./sounds/monster_kill.ogg";
            break;
        case "unstopable":
            text = "UNSTOPABLE"
            sound = "./sounds/unstopable.ogg";
            break;
    }
    $("#sound-text").html(text)
    $("#sound-text").addClass("animate__animated animate__heartBeat")
    var snd = new Audio(sound);
    snd.volume = 0.2;
    snd.play()
    setTimeout(function(){
    $("#sound-text").removeClass("animate__animated animate__heartBeat")
    $("#sound-text").html("")
    }, 2000);
}

// KILL FEED
const handleKillFeed = () => {
    const killToShow = kills.find((k) => k.shown === false);
    const index = kills.indexOf(killToShow);
    if (killToShow === null || killToShow === undefined || index === -1) {
      return;
    }
    killToShow.shown = true;
    kills[index] = killToShow;
    kills.splice(index, 1);
  
    var $newFeedElement = $killFeedElement.clone();
    $newFeedElement
      .find(".weapons img:first-child")
      .attr("src", "images/weapons/" + killToShow.weapon + ".png"); //drawing a weapon
      if (killToShow.headshot){
        $newFeedElement
        .find("#headshot")
        .attr("src", "images/headshot.png"); //drawing a weapon
      }
    $newFeedElement.find(".killer").html(killToShow.killer); //drawing a "teammate"
    $newFeedElement.find(".victim").html(killToShow.victim); //drawing a "enemy"
    $killFeedContainer.append(
      $newFeedElement
        .show()
        .delay(2000)
        .fadeOut(1000, function () {
          //drawing a container
          $(this).remove();
        })
    );
};
const addKill = (k, v, w,h) => {
    kills.push({
        killer: k,
        victim: v,
        weapon: w,
        headshot:h,
        shown: false,
        time: Date.now(),
    });
};
  
window.setInterval(() => {
    handleKillFeed();
}, 450);