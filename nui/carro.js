const returnDetido = (sts) => {
    return (sts == 1) ? 'Detido' : 'Garagem'

}

const getCar = () => {
    $.post("http://vrp_control_people/getCars", JSON.stringify({}), (data) => {
        const nameList2 = data.cars.sort((a, b) => (a.name > b.name) ? 1 : -1);

        $(".invRight").html("");
        for (let x = 1; x <= nameList2.length ; x++) {
            const slot = x.toString();
            if (nameList2[x - 1] !== undefined) {
                const v = nameList2[x - 1];
                const item = ` <a class="btnTransparente" onclick="modalDinamic('${v.name}', '${v.vehicle}', '${v.detido}', '${v.fuel}', '${v.engine}', '${v.body}')"> 
                     <div class="item populated" style="background-image: url('http://189.1.172.114/images/${v.vehicle}.png'); 
                          background-position: center; background-repeat: no-repeat;"
                          data-item-key="${v.key}" data-name-key="${v.name}" data-amount="${v.amount}" data-slot="${slot}">
					<div class="top">
						<div class="itemWeight">${formatarNumero((v.ipva).toFixed(2))}</div>
						<div class="itemAmount">${returnDetido(v.detido)}</div>
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

function modalDinamic(name, vehicle, detido, fuel, engine, body) {
    $(".modal-content").empty();

    let header = `<div class="modal-header"> <button type="button" class="close" data-dismiss="modal">&times;</button>
    <h4 class="modal-title">${name}</h4> </div>
    <div class="modal-body">
    <div class='row'>
        <div class="col-md-5">
            <div class="item populated imageSize" style="background-image: url('http://189.1.172.114/images/${vehicle}.png');
                        background-position: center; background-repeat: no-repeat;"> 
            </div>
        </div>
        <div class="col-md-5">
            <h4>${returnDetido(detido)}</h4>
            <h6><label for="file">Gas:</label>
            <progress id="file" value="${fuel}" max="100"> ${fuel}% </progress></h6>
            <h6><label for="file">Mot:</label>
            <progress id="file" value="${engine}" max="1000"> ${engine}% </progress></h6>
            <h6><label for="file">Lat: </label>
            <progress id="file" value="${body}" max="1000"> ${body}% </progress></h6>
        </div>
    </div>
    <div class="modal-footer">
       <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
    </div>`;

    $(".modal-content").append(header)

    $("#myModal").modal({
        show: true
    });
}
