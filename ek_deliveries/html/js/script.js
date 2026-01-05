$(function () {
    function display(bool) {
        if (bool) {
            $("#ui").show();
        } else {
            $("#ui").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            display(item.status)
        }else if(item.type == "fillData"){
            FillContainer(item.data,item.pldata)
        }
    });

    document.onkeyup = function (data) {
		if (data.which == 27) {
			display(false)
            Exit()
		}
	};

    $("#ui").on("click", "#setgps", function() {
        let location = $(this).attr("location")
        $.post('http://ek_deliveries/setgps', JSON.stringify({
            location:location
        }))
        Exit()
    });

    $("#ui").on("click", "#delete", function() {
        $.post('http://ek_deliveries/delete', JSON.stringify({}))
        Exit()
    });
});

function FillContainer(data){
    $("#ui").html("");
    $("#ui").html(
        `<div id="container"></div>`
    );
    let location = data.location
    $("#container").append(
        `<div id="card">
            <div id="header">
                <div id="label">
                    MY DELIVERY
                </div>
            </div>
            <div id="info">
                <div id="info_div">
                    <div id="infoheader">
                        <div>
                            PRODUCTS
                        </div>
                    </div>
                    <div id="items">
                    </div>
                </div>
            </div>
            <div id="bottom-side">
                <div class="bts">
                    <div id="reward">
                        Your earnings: <span id="earnings">`+data.reward+`$</span>
                    </div>
                    <div id="buttons">
                        <div id="setgps" location=`+data.location+`>
                            SET GPS
                        </div>
                        <div id="delete">
                            DELETE
                        </div>
                    </div>
                </div>
            </div>
        </div>`
    )
    for (let a=0;a<data.items.length;a++){
        let item = data.items[a]
        $("#items").append(
            `<div>x`+data.amount +` `+ item+`</div>`
        )
    }
}

function Exit(){
    $.post('http://ek_deliveries/exit', JSON.stringify({}))
    return
}