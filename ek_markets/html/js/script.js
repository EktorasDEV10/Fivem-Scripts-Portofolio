var SHOPS = [];
var money = 0;
var currentShop = null;
var currentpage = 1;
var totalpages = 1; 
var productsPerPage = 10;
var currentcategory = null;

function display(bool) {
    if (bool) {
        $("#shopmenu").show();
    } else {
        $("#shopmenu").hide();
    }
}

$(function () {

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;

        if (item.type === "shop"){
            display(item.display)
        }
        if (item.type === "fill"){
            var data = item.data
            SHOPS = data
        }
        if (item.type === "open"){
            if (item.display){
                currentpage = 1
                currentShop = item.shop
                $("#shopmenu").css('background', "url('images/"+SHOPS[item.shop].backgroundImage+"') no-repeat")
                $("#shopmenu").css('background-size', "100% 100%")
                $("#shopmenu").css('background-position', "center")
                FillShopMenu(SHOPS[item.shop])
            }else display(false)
        }
        if (item.type === "notif"){
            $("#notif").html(
                `
                <div class="${item.action}" id="notif-main">
                    <div id="notif-main-title">
                        <i class="fas fa-times"></i> 
                    </div>
                    <div id="notif-main-text">
                        ${item.msg}
                    </div>
                </div>
                `
            )
            $("#notif").addClass("animate__animated animate__fadeInUp")
            setTimeout(function(){
                $("#notif").removeClass("animate__animated animate__fadeInUp")
                $("#notif").html("")
            }, 3000);
        } 
        if (item.type === "open-key"){
            if (item.show){
                $("#draw-screen").html('PRESS <span>[E]</span> <i class="fas fa-arrow-right"></i> ' + item.shop)
            }else $("#draw-screen").html("")
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) {
            currentShop = null
            Exit()
            return
		}
	};
});

function Exit(){
    $.post('http://ek_markets/exit', JSON.stringify({}))
    return
}

function ChangeCategory(category){
    if (SHOPS[currentShop].products[category] == undefined){
        $("#shopmenu-container-main-center").html("")
        return
    }
    currentcategory = category
    currentpage = 1;
    FillProducts(SHOPS[currentShop].products[category])
}

function BuyWeapon(name,price,moneyType){
    $.post('http://ek_markets/buyWeapon', JSON.stringify({
        name:name,
        price:price,
        moneyType:moneyType
    }))
}
function BuyItem(key,name,price,moneyType){
    let amount = $(".shopmenu-container-main-box-"+key+" #shopmenu-container-main-box-price-amount-number").text()
    amount = amount.split(' ').join('')
    price = price*amount 
    $.post('http://ek_markets/buyItem', JSON.stringify({
        name:name,
        price:price,
        amount:amount,
        moneyType:moneyType
    }))
}

function AddItem(key){
    let classname = $(".shopmenu-container-main-box-"+key+" #shopmenu-container-main-box-price-amount-number")
    let amount = classname.text()
    let price = SHOPS[currentShop].products[currentcategory][key].price
    amount = amount.split(' ').join('')
    amount = parseInt(amount) + 1;
    classname.html(amount)
    $(".shopmenu-container-main-box-"+key+" #shopmenu-container-main-box-price-buy").html(price*amount + " $")
}

function RemoveItem(key){
    let classname = $(".shopmenu-container-main-box-"+key+" #shopmenu-container-main-box-price-amount-number")
    let amount = classname.text()
    amount = amount.split(' ').join('')
    amount = parseInt(amount);
    let price = SHOPS[currentShop].products[currentcategory][key].price
    if (amount > 1){
        amount = parseInt(amount) - 1;
        classname.html(amount)
        $(".shopmenu-container-main-box-"+key+" #shopmenu-container-main-box-price-buy").html(price*amount + " $")
    }
}

function PreviousPage(){
    if (currentpage == 1){
        currentpage = totalpages
    }else currentpage--
    $("#shopmenu-pages-current").html(currentpage)
    FillProducts(SHOPS[currentShop].products[currentcategory])
}

function NextPage(){
    if (currentpage == totalpages){
        currentpage = 1
    }else currentpage++
    $("#shopmenu-pages-current").html(currentpage)
    FillProducts(SHOPS[currentShop].products[currentcategory])
}

function FillShopMenu(data){
    $("#shopmenu").html(
        `        
        <div id="shopmenu-container">
            <div id="shopmenu-container-header">
                <div id="shopmenu-container-header-label">
                    
                </div>
            </div>
            <div id="shopmenu-container-categories"> </div>
            <div id="shopmenu-container-main">
                <div id="shopmenu-pages">
                    <span id="shopmenu-pages-current">1</span>/<span id="shopmenu-pages-max">6</span> 
                </div>
                <div id="shopmenu-container-main-left" onclick="PreviousPage()">
                    <i class="fas fa-chevron-left"></i>
                </div>
                <div id="shopmenu-container-main-center"> </div>
                <div id="shopmenu-container-main-right" onclick="NextPage()">
                    <i class="fas fa-chevron-right"></i>
                </div>
            </div>
        </div>
        `
    )
    $("#shopmenu-container-header-label").html(data.label)
    $.each(data.categories, function(key,value){
        $("#shopmenu-container-categories").append(
            `
            <div id="shopmenu-container-categories-selection" onclick="ChangeCategory('${value}')">
                ${value.toUpperCase()}
            </div>
            `
        )
    })
    currentcategory = data.categories[0]
    FillProducts(data.products[data.categories[0]])
    display(true)
}

function FillProducts(products){
    let prolength = products.length
    totalpages = Math.ceil(prolength/productsPerPage)
    let minpro = (productsPerPage*currentpage) - productsPerPage
    let maxpro = minpro + productsPerPage - 1
    if (products[minpro] == undefined) return
    $("#shopmenu-pages-current").html(currentpage)
    $("#shopmenu-pages-max").html(totalpages)
    $("#shopmenu-container-main-center").html("")
    $.each(products, function(key,value){
        let element = null;
        if (key < minpro || key > maxpro) return  
        if (value.type == "weapon"){
            element = `
                <div id="shopmenu-container-main-box">
                    <div id="shopmenu-container-main-box-label">
                        ${value.label}
                    </div>  
                    <div id="shopmenu-container-main-box-image">
                        <img src="images/${value.name}.png">
                    </div>
                    <div id="shopmenu-container-main-box-price" class="weapon-box" class="weapon-box">
                        <div id="shopmenu-container-main-box-price-buy" onclick="BuyWeapon('${value.name}','${value.price}','${value.moneyType}')">
                            ${value.price} $
                        </div>
                    </div>
                </div>
            `
        }else if (value.type == "item"){
            element = `
                <div id="shopmenu-container-main-box" class="shopmenu-container-main-box-${key}">
                    <div id="shopmenu-container-main-box-label">
                        ${value.label}
                    </div>  
                    <div id="shopmenu-container-main-box-image">
                        <img src="images/${value.name}.png">
                    </div>
                    <div id="shopmenu-container-main-box-price"class="item-box">
                        <div id="shopmenu-container-main-box-price-amount">
                            <div id="shopmenu-container-main-box-price-remove" onclick="RemoveItem('${key}')">
                                <i class="fas fa-minus"></i>
                            </div>
                            <div id="shopmenu-container-main-box-price-amount-number"> 1 </div>
                            <div id="shopmenu-container-main-box-price-add" onclick="AddItem('${key}')">
                                <i class="fas fa-plus"></i>
                            </div>
                        </div>
                        <div id="shopmenu-container-main-box-price-buy" onclick="BuyItem(${key},'${value.name}','${value.price}','${value.moneyType}')">
                            ${value.price} $
                        </div>
                    </div>
                </div>
            `
        }
        $("#shopmenu-container-main-center").append(element)
    })

}