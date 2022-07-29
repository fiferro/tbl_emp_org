
function addUserGroup(idGrupo, userId) {
    $.post("http://vrp_control_people/postGroupUser", JSON.stringify({ user_id: userId, id_grupo: idGrupo }), (data) => {
        updateGrouUser(idGrupo)
    })
}

function removerGrupouser(idGrupo, userid) {
    $.post("http://vrp_control_people/delGroupUser", JSON.stringify({ user_id: userid, id_grupo: idGrupo }), (data) => {
        updateGrouUser(idGrupo)
        $('#myModal').modal('hide');
    })
}

function removerGrupo(idGrupo) {
    $.post("http://vrp_control_people/delGroup", JSON.stringify({ id_grupo: idGrupo }), (data) => {
        getGroup()
        $('#myModal').modal('hide');
    })
}

function abrirModal() {
    $(".modal-content").empty();

    let header = `<div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Voce deseja criar um grupo</h4>
                </div>
                <div class="modal-body">
                    <div>
                        <input id="txtGrupo" type="text" placeholder="Informe o nome do grupo">
                        <p  style="display: none" id='poNameGrup'>Preenchimento Obrigatório</p> 
                    </div>
                    <div>
                        <input id="txtRadio" type="number" placeholder="Informe o numero da frequência">
                        <p style="display: none" id='poFeqGroup'>Preenchimento Obrigatório</p> 
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" onclick="criarGrupo()">Criar</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>`;

    $(".modal-content").append(header)

    $("#myModal").modal({
        show: true
    });
}

const selectGroup = (sel) => {
    updateGrouUser(sel.value);
};

const updateGrouUser = (idGroup) => {
    $.post("http://vrp_control_people/requestGroupUsers", JSON.stringify({ idGroup: idGroup }), (data) => {
        const nameList2 = data.group;
        $(".invRight").html("");
        if (nameList2[0].lider === 1) {
            liderGroup = 1
            liderId = nameList2[0].user_id
            let button = `<a class="btnTransparente" onclick="modalDinamicAddUser('${idGroup}')">
                            <div class="item populated" data-slot="-1">  
                                 ADICIONAR PESSOA
                        </div> </a>`
            $(".invRight").append(button);
        } else {
            liderGroup = 0
            liderId = 0
        }

        for (let x = 1; x <= nameList2.length ; x++) {
            const slot = x.toString();
            if (nameList2[x - 1] !== undefined) {
                const v = nameList2[x - 1];
                let foto = v.foto ? v.foto : 'img/nophoto.png'
                const item = `<a class="btnTransparente"  onclick="modalDinamicUser('${v.name}', '${v.phone}', '${v.registration}', '${v.foto}', '${v.id_grupo}', '${v.user_id}', '${liderGroup}')"> 
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
    });
}

function criarGrupo() {
    let name = $("#txtGrupo").val()
    let radio = $("#txtRadio").val()
    let sucesso = true;
    if (!radio){
        $("#poFeqGroup").show()
        sucesso = false
    }else {
        $("#poFeqGroup").hide()
    }
    if (!name){
        $("#poNameGrup").show()
        sucesso = false
    }else {
        $("#poNameGrup").hide()
    }
  
    if (sucesso ){
        $.post("http://vrp_control_people/postGroup", JSON.stringify({ name: name, radio: radio }), (data) => {
            $('#myModal').modal('hide');
            getGroup();
        })
    }
  
}

function modalDinamicUser(name, phone, registration, foto, id_grupo, userid, lider) {
    $(".modal-content").empty();
    let liderButton = ''
    if (Number(lider) === 1 && liderId !== Number(userid)) {
        liderButton = `<button type="button" class="btn btn-default" onclick="removerGrupouser('${id_grupo}','${userid}')">Remover</button>`
    }
    if (Number(lider) === 1 && liderId === Number(userid)) {
        liderButton = `<button type="button" class="btn btn-default" onclick="removerGrupo('${id_grupo}')">Excluir Grupo</button>`
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

function getGroup() {
    $('#cmbGroup').empty();
    $(".invRight").empty();
    let option = '<option>Selecione o seu grupo</option > ';
    $.post("http://vrp_control_people/requestGroup", JSON.stringify({}), (data) => {
        let group = data.group;
        for (let i = 0; i < group.length; i++) {
            option += '<option value="' + group[i].id + '">' + group[i].nome + '( ' + group[i].radio + ' )' + '</option>';
        }
        $('#cmbGroup').append(option);
    })
}