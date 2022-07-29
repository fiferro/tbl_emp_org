$(function () {
    // Everest.getImage("GdgZthP", function (url) {
    //     $("#img_pessoa").attr("src", url.replace(".jpg", "l.jpg"));
    // });

    eventDiv('home')
    Everest.init();
});
var htmlOriginal = $(".body").html();
var time = 20000;
var bloq = false;
var passaporteAtual = 0;
var passportAdd = 0;
var liderGroup = 0;
var liderId = 0;
var org = '';
var mySlots = 50;
var inSlots = 100;
var shiftPressed = false;

var Everest = {}
Everest = {
    init: function () {
        Everest.setImage();
        window.addEventListener('message', function (event) {
            if (event.data.type === "notebook") {
                $("#painel_control_people").fadeIn();
                $("#principal").show();
            }
            if (event.data.type === "fecharTablet") {
                $("#painel_control_people").fadeOut();
                $('#myModal').modal('hide');
            }
        });

        document.onkeyup = function (data) {
            if (data.which == 27) {
                eventDiv('home')
                Everest.sendData("ButtonClick", { action: "fecharTablet" }, false);
                $('#myModal').modal('hide');
            }
        }

        $("#painel_control_people .body").height($('#painel_control_people').height() - $(".header").height());
        window.onresize = function () {
            $("#painel_control_people .body").height($('#painel_control_people').height() - $(".header").height());
        }

        $('.modal').on('hidden.bs.modal', function () {
            $('.modal .modal-body').html("");
        });
    },

    setImage: function () {
        var passaporte = passaporteAtual;
        $("#img_pessoa").click(function () {
            $("input[id='my_file']").click();
            return false;
        });

        $("input[id='my_file']").on("change", function () {

            var $files = $(this).get(0).files;

            if ($files.length) {

                // Reject big files
                if ($files[0].size > $(this).data("max-size") * 1024) {
                    return false;
                }

                // Replace ctrlq with your own API key
                var apiUrl = 'https://api.imgur.com/3/image';
                var apiKey = '9576bf13ee7a1fd';

                var settings = {
                    async: false,
                    crossDomain: true,
                    processData: false,
                    contentType: false,
                    type: 'POST',
                    url: apiUrl,
                    headers: {
                        Authorization: 'Client-ID ' + apiKey,
                        Accept: 'application/json'
                    },
                    mimeType: 'multipart/form-data'
                };

                Everest.Alert("info", "Aguarde...");

                setTimeout(function () {
                    var formData = new FormData();
                    formData.append("image", $files[0]);
                    // formData.append("album", "everest");
                    // formData.append("title", "Foto de perfil");
                    settings.data = formData;

                    // Response contains stringified JSON
                    // Image URL available at response.data.link

                    $.ajax(settings).done(function (response) {
                        var json = JSON.parse(response);

                        Everest.sendData("ButtonClick", { action: "updateFoto", foto: json.data.link, user_id: passaporte });
                        Everest.Alert("success", "Foto atualizada com sucesso!", true);
                    });
                }, 500);

            }
        });
    },
    getImage: function (img, rec) {
        $.ajax({
            type: "GET",
            url: "https://api.imgur.com/3/album/" + img + "/images",
            dataType: "text",
            beforeSend: function (xhr) {
                xhr.setRequestHeader('Authorization', 'Client-ID 9576bf13ee7a1fd');
            },
            success: function (data) {
                var json = $.parseJSON(data);
                var links = json.data.map(function (item) {
                    rec(item.link);
                });
            }
        });
    },

    uploadImgur: function (file, upload) {
        // Replace ctrlq with your own API key
        var apiUrl = 'https://api.imgur.com/3/image';
        var apiKey = '9576bf13ee7a1fd';

        var settings = {
            async: false,
            crossDomain: true,
            processData: false,
            contentType: false,
            type: 'POST',
            dataType: 'json',
            url: apiUrl,
            headers: {
                Authorization: 'Client-ID ' + apiKey,
                Accept: 'application/json'
            },
            // mimeType: 'multipart/form-data'
        };

        var formData = new FormData();
        file = file.replace('data:image/jpeg;base64,', "");
        file = file.replace('data:image/png;base64,', "");
        formData.append("image", file);
        settings.data = formData;

        // Response contains stringified JSON
        // Image URL available at response.data.link
        Everest.Alert("info", "Aguarde...");
        $.ajax(settings).done(function (json) {
            upload(json.data.link);
        });

    },

    Alert: function (type, msg, bloquear) {
        if (bloq == false) {
            bloq = (bloquear == null ? false : bloquear);

            $("#alert").html(msg).removeClass().addClass(type).fadeIn();

            setTimeout(function () {
                $("#alert").fadeOut();
                bloq = false;
            }, 10000);
        }
    },
    AlertClose: function () {

        setTimeout(function () {
            if (bloq === false) {
                $("#alert").fadeOut();
            }
        }, 500);

    },
    sendData: function (name, data, load) {
        var time = 0;
        if (load !== false) {
            Everest.Alert("info", "Aguarde...");
            time = 500;
        }
        setTimeout(function () {
            $.post("http://vrp_control_people/" + name, JSON.stringify(data));
        }, time);
    },
    newModal: function (title, html) {
        var random = Math.floor((Math.random() * 100) + 1);
        var modalHtml = '<div class="modal fade" tabindex="-1" role="dialog" id="modal' + random + '">' +
            '<div class="modal-dialog modal-md" role="document">' +
            '<div class="modal-content">' +
            '<div class="modal-header">' +
            '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>' +
            '<h4 class="modal-title">' + title + '</h4>' +
            '</div>' +
            '<div class="modal-body">' + html + '</div>' +
            '</div>' +
            '</div>' +
            '</div>';

        $("#modals").append(modalHtml);
        $('#modal' + random).modal("show");
        $('#modal' + random).on('hidden.bs.modal', function () {
            $(this).remove();
        });
    }
}

function imgMD(img) {
    img = img.replace(".jpg", "l.jpg");
    img = img.replace(".png", "l.png");

    return img;
}

// divs atualização 
function cleanDiv() {
    $("#divBau").hide();
    $("#divCarro").hide();
    $("#divGroup").hide();
    $("#divFac").hide();
    $("#principal").hide();
    $("#fechar").show();    
    cleanDivEmp()

}

function eventDiv(div) {
    cleanDiv()
    switch (div) {
        case 'bau':
            $("#divBau").show();
            updateChest();
            getHouse();
            $(".inventory").css("display", "flex")
            break;
        case 'carro':
            $("#divCarro").show();
            getCar();
            $(".inventory").css("display", "flex")
            break;
        case 'grupo':
            $("#divGroup").show();
            getGroup();
            $(".inventory").css("display", "flex")
            break;
        case 'fac':
            $("#divFac").show();
            $(".invRight").empty();
            getLider();
            $(".inventory").css("display", "flex")
            break;
        case 'emp':
            $("#divEmp").show();
            buscaEmpUser();
            break;
        case 'home':
            $("#principal").show();
            $("#fechar").hide();    
            break;
    }
}

const formatarNumero = (n) => {
    var n = n.toString();
    var r = '';
    var x = 0;

    for (var i = n.length; i > 0; i--) {
        r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
        x = x == 2 ? 0 : x + 1;
    }

    return r.split('').reverse().join('');
}

function getHouse() {
    $('#cmbBau').empty();
    $(".invRight").empty();
    let option = '<option>Selecione sua casa</option > ';
    $.post("http://vrp_control_people/requestHouse", JSON.stringify({}), (data) => {
        let house = data.houses;
        for (let i = 0; i < house.length; i++) {
            option += '<option value="' + house[i].home + '">' + house[i].home + '</option>';
        }
        $('#cmbBau').append(option);
    })
}

function modalDinamicAddUser(idGrupo) {
    $(".modal-content").empty();

    let header = `<div class="modal-header"> <button type="button" class="close" data-dismiss="modal">&times;</button>
    <h4 class="modal-title">Adicionar pessoa</h4> </div>
    <div class="modal-body">
    <div class='row'>
        <div class="col-md-12">
             <input id="txtPass" type="text" placeholder="Informe o passaporte">
             <button type="button" class="btn btn-default" onclick="pesquisarPessoa(${idGrupo})">procurar</button>
        </div>
    </div>
    <div id='dvPass' class='row'>
    </div>
    <div class="modal-footer">      

       <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
    </div>`;

    $(".modal-content").append(header)

    $("#myModal").modal({
        show: true
    });
}

function pesquisarPessoa(idGrupo) {
    let passporte = $("#txtPass").val()
    $('#dvPass').empty();
    $.post("http://vrp_control_people/requestPassport", JSON.stringify({ user_id: passporte }), (data) => {
        let passport = data.passport;
        for (let i = 0; i < passport.length; i++) {
            const option = `<div class="col-md-3"> <h6>Fone: ${passport[i].phone} </h6> </div>
           <div class="col-md-3"> <h6>name: ${passport[i].name} </h6> </div>
           <div class="col-md-3">
             <button type="button" class="btn btn-default" onclick="addUserGroup('${idGrupo}','${passport[i].user_id}')">adicionar</button>
           </div>   `;
            $('#dvPass').append(option);
        }

    })
}

