const updateChest = (home) => {
    $.post("http://vrp_control_people/requestChest", JSON.stringify({ homes: home }), (data) => {
        const nameList2 = data.inventario2.sort((a, b) => (a.name > b.name) ? 1 : -1);
        $(".invRight").html("");
        for (let x = 1; x <= nameList2.length ; x++) {
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



const selectChest = (sel) => {
    updateChest(sel.value);
};