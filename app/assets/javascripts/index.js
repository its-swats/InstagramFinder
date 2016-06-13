$(document).ready(function() {
	preparePage();
	toggleSearch();
	verifyForm();
	sidebarClick();
})

function preparePage(){
	if (window.location.search == ''){
		$('.initial-form:nth-child(2)').hide();	
		$('input:submit').prop('disabled', true);
	} else {
		$('.nav-item').hide();
	};
};

function toggleSearch(){
	$('.nav-item').on('click', function(e){
		e.preventDefault()
		if ($(this).text() == "Search") {
			$('.nav-item:first-child').removeClass('active');
			$('.nav-item:nth-child(2)').addClass('active');
			$('.initial-form:first-child').hide();
			$('.initial-form:nth-child(2)').show();
		} else {
			$('.nav-item:first-child').addClass('active');
			$('.nav-item:nth-child(2)').removeClass('active');
			$('.initial-form:first-child').show();
			$('.initial-form:nth-child(2)').hide();
		};
	});
};

function verifyForm(){
	$('form').change(function(e){
		if (verifyHashtag(e) && verifyDate(e)) {
			$(e.target).parent().parent().find('input:submit').prop('disabled', false);
		} else {
			$(e.target).parent().parent().find('input:submit').prop('disabled', true);
		};
	});
};

function verifyHashtag(e){
	return !!$(e.target).parent().parent().find("input[name='request[hashtag]']").val();
};

function verifyDate(e){
	var start_date = Date.parse($(e.target).parent().parent().find("input[name='request[start_date]']").val());
	var end_date = Date.parse($(e.target).parent().parent().find("input[name='request[end_date]']").val());
	var current_date = Date.now();
	return end_date <= current_date && start_date <= end_date
};

function sidebarClick() {
	$('.sidebar-link').on('click', function(event){
		event.preventDefault();
		var clickedLink = $(this).text();
		$("input[name='request[hashtag]'").val(clickedLink); 
	});
};