<!DOCTYPE html>
<?php
    $database = new SQLite3('example.db');
    $score_query = $database->query('SELECT * FROM results');
    $scores = array();
    while($score_data = $score_query->fetchArray()) {
        $scores[$score_data['lecture']][] = $score_data;
    }
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
            var _current_slide = <?=ceil(count($scores) / 2)?>;
            var SLIDE_NUM = <?=count($scores)?>;

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
    
    <body onload="open_slide(_current_slide)">
        <header>
            <h1>StudyScores V0.3</h1>
            <nav>
                <input type="button" name="prev" value="Previous Slide" onclick="open_slide(--_current_slide)" />
                <input type="button" name="next" value="Next Slide" onclick="open_slide(++_current_slide)" />
            </nav>
        </header>
        <div id="slide_area">
<?php
    $i = 1;
    foreach ($scores as $lecture => $data) {
        // Parse scores from crappy db structure :-D
        $hw_possible_sum = 0;
        $hw_result_sum = 0;
        $on_possible_sum = 0;
        $on_result_sum = 0;
        
        foreach ($data as $element) {
            $hw_possible_sum += $element['hw_possible'];
            $hw_result_sum += $element['hw_result'];
            $on_possible_sum += $element['on_possible'];
            $on_result_sum += $element['on_result'];
        }
?>
            <div id="<?=$i++?>" class="slide">
                <section class="slide_content">
                    <h2><?=$lecture?></h2>
                    <table width="100%">
                        <tr>
                            <td align="right">
                                <p class="score"><?=$hw_result_sum.'/'.$hw_possible_sum?></p>
                            </td>
                            <td align="right">
                                <p class="score"><?=$on_result_sum.'/'.$on_possible_sum?></p>
                        </tr>
                        <tr>
                            <td align="right">
                                <p class="description">hausaufgabenPUNKTE</p>
                            </td>
                            <td align="right">
                                <p class="description">onlinePUNKTE</p>
                            </td>                            
                        </tr>
                     </table>
                </section>
            </div>
<?php
    }
?>
        </div>
    </body>
</html>
