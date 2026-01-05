$(function () {

    function display(bool){
      if (bool) {
        $("#container").show();
      } 
      else {
          $("#container").hide();
      }
    }
  
    display(false)
  
    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type == "startCapture") {
            display(true)
            // document.getElementById("progressBar").innerHTML = item.progress + '%';
            const progress_bars = document.querySelectorAll('#progressBar');
			progress_bars.forEach(bar => {
                const { size } = bar.dataset;
                bar.style.width = ``+item.progress+`%`;
            });
        }else if (item.type == 'stopCapture'){
            display(false)
            $.post('http://ek_capture/capture_success', JSON.stringify({}));
            return;
        }else if (item.type == 'toggle'){
            display(item.bool)
        }
    })
  
  })