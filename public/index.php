<!DOCTYPE html>
<?php
    $database = new SQLite3('example.db');
    $score_query = $database->query('SELECT * FROM results');
    $scores = array();
    while($score_data = $score_query->fetchArray()) {
        $scores[$score_data['lecture']][] = $score_data;
    }
    var_dump($scores);
?>
<html>
    <head>
        <!-- Für unseren Lieblingsbrowser aus dem Hause Microsoft: -->
        <!--[if lt IE 9]>
        <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->

        <!-- Sonstiger HEAD-Kram -->
        <meta charset="utf-8">
        <title>StudyScores 0.3 <?='PHP Powered'?></title>
        <link href="studyscores.css" rel="stylesheet" type="text/css" />

        <script type="text/javascript">
            var _current_slide = 2;
            var SLIDE_NUM = 3

            function open_slide(num) {
                // Grenzüberschreitungen verhindern
                num = Math.max(1, num);
                num = Math.min(num, SLIDE_NUM);
                _current_slide = num;
                
                // Alles bis auf 3 Slides unsichtbar schalten
                for(i = 1; i <= SLIDE_NUM; i++) {
                    position = 'invisible';
                    switch(i) {
                        case num - 1:
                            position = 'left';
                            break;
                        case num:
                            position = 'front';
                            break;
                        case num + 1:
                            position = 'right';
                            break;
                    }

                    document.getElementById("" + i).className = "slide " + position;
                }
            }
        </script>
    </head>
    
    <body>
        <header>
            <h1>StudyScores V0.3</h1>
            <nav>
                <input type="button" name="prev" value="Previous Slide" onclick="open_slide(--_current_slide)" />
                <input type="button" name="next" value="Next Slide" onclick="open_slide(++_current_slide)" />
            </nav>
        </header>
        <div id="slide_area">
            <div id="1" class="slide left">
                <section class="slide_content">
                    <h2>Datenstrukturen und Algorithmen</h2>
                <section>
            </div>
            <div id="2" class="slide front">
                <section class="slide_content">
                    <h2>Lineare Algebra für Informatiker</h2>
                </section>
            </div>
            <div id="3" class="slide right">
                <section class="slide_content">
                    <h2>Formale Systeme, Automaten, Prozesse</h2>
                </section>
            </div>
        </div>
    </body>
</html>