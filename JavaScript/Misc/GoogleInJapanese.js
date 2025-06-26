//Google検索日本語の結果のみ表示コマンドレット
javascript:void((function(){var l='ja',f=window.location.href;if(f.search(/google\.(co\.jp|com)\/search/)<0)return;if(f.search(/(\&hl=|\&lr=lang_)/)<0){f=f+'&hl='+l+'&lr=lang_'+l}else{f=f.replace(/\&hl=.{2}/,'&hl='+l);f=f.replace(/\&lr=lang_.{2}/,'&lr=lang_'+l);};window.open(f,'_self')})());

/*
var l='ja',f=window.location.href;
if(f.search(/google\.(co\.jp|com)\/search/)<0)return;if(f.search(/(\&hl=|\&lr=lang_)/)<0){
    f=f+'&hl='+l+'&lr=lang_'+l
}else{
    f=f.replace(/\&hl=.{2}/,'&hl='+l);
    f=f.replace(/\&lr=lang_.{2}/,'&lr=lang_'+l);
};
window.open(f,'_self')
*/
