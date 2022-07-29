var suaOrg = ''
var userIdLider = 0
function addUserOrgs(org, userId) {
    $.post("http://vrp_control_people/postOrgs", JSON.stringify({ user_id: userId, org: org }), (data) => {
        updateOrgUserOrg()
    })
}

function RemoveUserOrgs(org, userId) {
    $.post("http://vrp_control_people/removeUserOrgs", JSON.stringify({ user_id: userId, org: org }), (data) => {
        updateOrgUserOrg()
    })
}

function pesquisarPessoaOrg() {
    let passporte = $("#txtPass").val()
    $('#dvPass').empty();
    $.post("http://vrp_control_people/requestPassportSemOrg", JSON.stringify({ user_id: passporte }), (data) => {
        let passport = data.passport;
        for (let i = 0; i < passport.length; i++) {
            const option = `<div class="col-md-3"> <h6>Fone: ${passport[i].phone} </h6> </div>
           <div class="col-md-3"> <h6>name: ${passport[i].name} </h6> </div>
           <div class="col-md-3">
             <button type="button" class="btn btn-default" onclick="addUserOrgs('${suaOrg}','${passport[i].user_id}')">adicionar</button>
           </div>   `;
            $('#dvPass').append(option);
        }

    })
}

function modalDinamicAddUserOrg(org) {
    $(".modal-content").empty();

    let header = `<div class="modal-header"> <button type="button" class="close" data-dismiss="modal">&times;</button>
    <h4 class="modal-title">Adicionar pessoa</h4> </div>
    <div class="modal-body">
    <div class='row'>
        <div class="col-md-12">
             <input id="txtPass" type="text" placeholder="Informe o passaporte">
             <button type="button" class="btn btn-default" onclick="pesquisarPessoaOrg()">procurar</button>
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

const updateOrgUserOrg = () => {
    $("#suaFac").empty();
    $.post("http://vrp_control_people/requestOrgsLider", JSON.stringify({}), (data) => {
        let orgs = data.orgs;
        let facText
        liderGroup = 1 
        org = orgs[0].Lider
        $(".invRight").html("");
        suaOrg = orgs[0].org
        if (org || org.length > 0) {
            userIdLider = orgs[0].user_id 
            facText = '<h6>Voce é lider do ' + orgs[0].org.toUpperCase() + '</h6>';
            $('#suaFac').append(facText);
            let button = `<a class="btnTransparente" onclick="modalDinamicAddUserOrg('${org}')">
                            <div class="item populated" data-slot="-1">  
                                 ADICIONAR PESSOA
                        </div> </a>`
            $(".invRight").append(button);
        }else {
            liderGroup = 0 
            userIdLider = 0;
            facText = '<h6>Voce está no ' + orgs[0].org.toUpperCase() + '</h6>';
            $('#suaFac').append(facText);
        }
        for (let x = 1; x <= orgs.length; x++) {
            const slot = x.toString();
            if (orgs[x - 1] !== undefined) {
                const v = orgs[x - 1];
                let foto = v.foto ? v.foto : 'img/nophoto.png'
                const item = `<a class="btnTransparente" onclick="modalDinamicUserOrg('${v.name}', '${v.phone}', '${v.registration}', '${v.foto}', '${v.org}', '${v.user_id}', '${liderGroup}')"> 
                    <div class="item populated" style="background-image: url(${foto}); background-position: center; background-repeat: no-repeat;" data-slot="${slot}">
					<div class="top">
						<div class="itemWeight">${v.registration}</div>
						<div class="itemAmount">${v.phone}</div>
					</div>
					<div class="itemname">${v.name}</div>
				</div> </a>`;

                $(".invRight").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;

                $(".invRight").append(item);
            }
        }
    })
}

function modalDinamicUserOrg(name, phone, registration, foto, org, userid, lider) {
    $(".modal-content").empty();
    let liderButton = ''
    if (Number(userIdLider) !== Number(userid) ) {
        liderButton = `<button type="button" class="btn btn-default" onclick="RemoveUserOrgs('${org}','${userid}')">Remover</button>`
    }
    let header = `<div class="modal-header"> <button type="button" class="close" data-dismiss="modal">&times;</button>
    <h4 class="modal-title">${name}</h4> </div>
    <div class="modal-body">
    <div class='row'>
        <div class="col-md-5">
            <div class="item populated imageSize" style="background-image: url('${foto}');
                        background-position: center; background-repeat: no-repeat;"> 
            </div>
        </div>
        <div class="col-md-5">
            <h3>Fone: ${phone}</h3>
            <h3>Rg  : ${registration}</h3>
        </div>        
    </div>
    <div class="modal-footer">      
       ${liderButton}
       <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
    </div>`;

    $(".modal-content").append(header)

    $("#myModal").modal({
        show: true
    });
}


function eventDivOrg(div) {
    cleanDivOrg()
    if (div === 'bau') {
        $("#invbau").show();
        updateChestOrgs()
    }
    if (div === 'pes') {
        updateOrgUserOrg();
        $("#invbau").show();
    }
}

const updateChestOrgs = () => {
    $.post("http://vrp_control_people/requestChestOrgs", JSON.stringify({ orgs: suaOrg }), (data) => {
        const nameList2 = data.inventario2.sort((a, b) => (a.name > b.name) ? 1 : -1);
        $(".invRight").html("");
        for (let x = 1; x <= nameList2.length; x++) {
            const slot = x.toString();
            if (nameList2[x - 1] !== undefined) {
                const v = nameList2[x - 1];
                const item = `<div class="item populated" style="background-image: url('http://189.1.172.114/inventario/${v.index}.png'); background-position: center; background-repeat: no-repeat;" data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
					<div class="top">
						<div class="itemWeight">${(v.peso * v.amount).toFixed(2)}</div>
						<div class="itemAmount">${formatarNumero(v.amount)}x</div>
					</div>
					<div class="itemname">${v.name}</div>
				</div>`;

                $(".invRight").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;

                $(".invRight").append(item);
            }
        }
    });
}

function cleanDivOrg() {
    $("#group").hide();
    $("#invbau").hide();
    $(".invRight").empty();
}

function getLider() {
    $("#fac").empty();
    $('#cmbTipo').empty();
    $(".invRight").empty();  
    
    let option = '<option values="0">Membros</option > ';
    option += '<option values="1">Baú</option>';
        
    $('#cmbTipo').append(option);
    updateOrgUserOrg();
}

const selectOrg = (sel) => {
    eventDivOrg((sel.value === 'Membros' )?'pes': 'bau' );
};
