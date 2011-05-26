window.onload = function () {
    var r = Raphael(10, 10, 230, 230);
    r.g.piechart(110, 110, 100, [69,31]);
    var s = Raphael(250, 10, 230, 230);
    s.g.piechart(110, 110, 100, [70,30]);
    var t = Raphael(500, 10, 230, 230);
    t.g.piechart(110, 110, 100, [70,30]);
    var c = Raphael(10, 230, 230, 230);
    
    var x = c.g.barchart(0, 0, 230, 230, [[6, 18, 18, 12,18,9], [4, 2, 2, 8,2,11]], {stacked: true, type: "soft"});
    var a = Raphael(250, 230, 230, 230);
    
    var y = a.g.barchart(0, 0, 230, 230, [[5, 9, 12, 17,10,18], [4, 11, 8, 3,10,2]], {stacked: true, type: "soft"});
    
};