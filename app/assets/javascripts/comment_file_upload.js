$(document).ready(function() {
    $('#comment_files').change(function() {
        var reader;
        files = this.files;
        if (this.files && this.files[0]) {
            reader = new FileReader;
            reader.onload = function(e) {

                var data = new FormData();
                data.append('comment[post_id]', $('#comment_post_id').val());
                data.append('comment[id]', $('#comment_id').val());
                jQuery.each(jQuery('#comment_files')[0].files, function(i, file) {
                    data.append('files[file'+i+']', file);
                });

                jQuery.ajax({
                    url: 'comments/comment_file',
                    data: data,
                    cache: false,
                    contentType: false,
                    processData: false,
                    type: 'POST',
                    success: function(data){
                    }
                });
            };
            return reader.readAsDataURL(this.files[0]);
        }
    });
});