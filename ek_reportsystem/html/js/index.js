

$('document').ready(() => {
  $('#container').hide();
  window.addEventListener('message', (event) => {
    if (event.data.action === 'PutReports') {
      PutReports(event.data.reports);
    }else if(event.data.action === "ui"){
      if (event.data.type){
        $('#container').fadeIn(500);
      }else {
        $.post('https://ek_reportsystem/close', {});
        $('#container').fadeOut(500);
      }
    }else if(event.data.action === "bg"){
      $("#container").html(
        `<div id="report_menu">
          <div id="header">
            <div>
              <span id="header_icon"><i class="fas fa-user"></i></span> REPORT SYSTEM
            </div>
          </div>
          <div id="reports">
            <div> 
              <table id="report_table">
              </table>
            </div>
          </div>
        </div>`
      )
    
      $('#reports').css('background-image', "url(" + event.data.bg + ")");
    }
  });

  window.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
      $.post('https://ek_reportsystem/close', {});
      $('#container').fadeOut(500);
    }
  });

  $("#container").on("click", "#goto", function() {
    const dataId = $(this).data('id') 
    $.post(
      'https://ek_reportsystem/goto',
      JSON.stringify({
        id: $(this).data('id'),
      })
    );
  })

  $("#container").on("click", "#complete", function() {
    const dataId = $(this).data('id') 
    $.post(
      'https://ek_reportsystem/complete',
      JSON.stringify({
        id: dataId,
      })
    );
  })
});


const PutReports = (reports) => {
  $("#report_table").html("")
  $.each(reports, (key, value) => {
    console.log('JS ' + value.serverID + ' ' + value.status + ' ' + value.message + ' ' + value.status_staff)
    var newclass = ''
    var seen = 'not_seen'
    if (value.status){
      newclass = "report_active"
      seen = 'seen'
    }

    const newreport = `
      <tr class="`+newclass+`">
        <td id="reason">${value.message}</td>
        <td id="name">${value.name}[${value.serverID}]</td>
        <td id="staff" class="`+seen+`">${value.status_staff}</td>
        <td id="complete" data-id="${value.serverID}"><span>✔️DONE</span></td>
        <td id="goto" data-id="${value.serverID}"><span>🏃GOTO</span></td>
      </tr>
    `;

    $('#report_table').append(newreport);
  });
};
