var idEmp = 0
var trabalhando = 0;
var processado = 0;
var empregoAtivo = 0;
function cleanDivEmp() {
    $("#txtAtivar").hide();
    $("#empAtivar").hide();
    $("#txtParar").hide();
    $("#empParar").hide();
    $("#txtLivre").hide();
    $("#txtEmprego").hide();
    $(".invRight").html("");
    processado = 0;
}

function ativarEmp() {
    cleanDivEmp();
    $("#txtParar").show();
    $("#empParar").show();
    atualizaEmpUser('S')
    getNewJob();
}

function pararEmp() {
    cleanDivEmp();
    $("#txtAtivar").show();
    $("#empAtivar").show();
    atualizaEmpUser('N');
    $(".invRight").html("");
    if (empregoAtivo > 0 ){
     decliveJob();
    }
}

function buscaEmpUser() {
    $.post("http://vrp_control_people/getUserAtivo", JSON.stringify({}), (data) => {
        const empAtivo = data.empAtivo[0];
        if (empAtivo) {
            idEmp = empAtivo.id;
            cleanDivEmp()
            if (empAtivo.ativo === 'S') {
                getAceptJob();
                $("#txtParar").show();
                $("#empParar").show();
            } else {
                $("#txtAtivar").show();
                $("#empAtivar").show();
            }
        } else {
            idEmp = 0;
            $("#txtAtivar").show();
            $("#empAtivar").show();
        }
    });
}

function getNewJob() {
    $("#txtLivre").show();
    $("#txtEmprego").hide();
    getJob(0);
}

function getAceptJob() {
    $("#txtLivre").hide();
    $("#txtEmprego").show();
    getJob(idEmp);
}

function getJob(id) {
    $.post("http://vrp_control_people/getEmpJobs", JSON.stringify({ empUserId: id }), (data) => {
        const nameList2 = data.empDiarios.sort((a, b) => (a.nome > b.nome) ? 1 : -1);
        $(".invRight").html("");
        if (id === idEmp && nameList2.length > 0) {
            trabalhando = 1;
            empregoAtivo = nameList2[0].id;
        } else {
            trabalhando = 0;
            if (processado === 0) {
                processado = 1 
                getNewJob();
            }
        }

        for (let x = 1; x <= nameList2.length; x++) {
            const slot = x.toString();
            if (nameList2[x - 1] !== undefined) {
                const v = nameList2[x - 1];
                const item = ` <a class="btnTransparente" onclick="aceptJob('${v.id}', '${idEmp}')"> 
                     <div class="item populated" style="background-image: url('http://189.1.172.114/images/encomenda.png'); 
                          background-position: center; background-repeat: no-repeat;" data-slot="${slot}">
					<div class="top">
					</div>
					<div class="itemname">${v.nome}</div>
				</div> </a>`;
                $(".invRight").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;

                $(".invRight").append(item);
            }
        }
    });
}


function aceptJob(id, empUserId) {
    if (trabalhando === 0) {
        $.post("http://vrp_control_people/postAceitaEmprego", JSON.stringify({ empUserId: empUserId, id: id }), (data) => {
            getAceptJob()
            return;
        });
    }
}

function decliveJob() {
        $.post("http://vrp_control_people/postRemoveEmprego", JSON.stringify({ id: empregoAtivo }), (data) => {
            return;
        });
}

function atualizaEmpUser(ativo) {
    $.post("http://vrp_control_people/postEmpUser", JSON.stringify({ ativo: ativo, id: idEmp }), (data) => {
        return;
    });
}

