$(function () {
	$('textarea').keypress(function(e) {
        var code = (e.keyCode ? e.keyCode : e.which);
        if (code == 13) {
            $('form').submit();
            return true;
        }
    });
});