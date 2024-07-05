const next_button = document.getElementById("next-button");
let page = 0;
next_button.addEventListener("click", next_page);
const BUTTON = {
	ENABLE: "enable",
	DISABLE: "disable"
};

function next_page(_){
	setButtonState(next_button, BUTTON.DISABLE);
	const job_container = document.getElementById("job-container");
	fetch(`/scroll?page=${page + 1}`)
		.then(resp => resp.text())
		.then(html => {
			debugger;
			if(html == ""){
				page = -1;
				setButtonState(next_button, BUTTON.DISABLE);
				return;
			}
			job_container.insertAdjacentHTML('beforeend', html);
			page += 1;
		})
		.catch(e => {
			console.error("some error occured while fetching new content", e);
		})
		.finally(() => {
			if(page >= 0)
				setButtonState(next_button, BUTTON.ENABLE);
		})
}

function setButtonState(btn, state){
	switch(state) {
		case BUTTON.ENABLE:
			btn.removeAttribute("disabled");
			btn.classList.remove("cursor-not-allowed");
		break;
		case BUTTON.DISABLE:
			btn.setAttribute("disabled", "disabled");
			btn.classList.add("cursor-not-allowed");
		break;
	}
}