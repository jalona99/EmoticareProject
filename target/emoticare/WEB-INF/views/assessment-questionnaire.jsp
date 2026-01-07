<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Questionnaire - EmotiCare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background: #1a1d2e;
            color: #ffffff;
            min-height: 100vh;
            padding: 40px 20px;
        }
        .container { max-width: 800px; margin: 0 auto; }
        .progress-container { margin-bottom: 40px; }
        .progress-text { color: #9ca3af; font-size: 14px; margin-bottom: 8px; }
        .progress-bar { width: 100%; height: 8px; background: #2d3142; border-radius: 4px; overflow: hidden; }
        .progress-fill { height: 100%; background: linear-gradient(90deg, #6366f1 0%, #8b5cf6 100%); transition: width 0.5s ease; }
        .question-card { background: #242838; border-radius: 20px; padding: 48px; border: 1px solid #2d3142; margin-bottom: 32px; }
        .question-number { color: #6366f1; font-size: 14px; font-weight: 600; margin-bottom: 8px; }
        .question-text { font-size: 22px; font-weight: 600; line-height: 1.5; margin-bottom: 32px; }
        .options { display: flex; flex-direction: column; gap: 12px; }
        
        .radio-option {
            display: flex; 
            align-items: center; 
            padding: 16px 20px;
            background: #1a1d2e; 
            border: 2px solid #2d3142; 
            border-radius: 12px;
            cursor: pointer; 
            transition: all 0.2s ease;
        }
        .radio-option:hover { border-color: #6366f1; background: #242838; }
        .radio-option.selected { border-color: #6366f1; background: rgba(99, 102, 241, 0.1); }
        .radio-option input[type="radio"] { 
            margin-right: 16px; 
            width: 20px; 
            height: 20px; 
            accent-color: #6366f1;
            flex-shrink: 0;
        }
        .radio-label {
            color: #ffffff;
            font-size: 16px;
            font-weight: 500;
            flex: 1;
        }
        
        .btn-group { display: flex; gap: 16px; }
        .btn {
            flex: 1; padding: 14px 24px; border: none; border-radius: 8px;
            font-weight: 600; cursor: pointer; transition: all 0.3s ease;
        }
        .btn-prev { background: #2d3142; color: #ffffff; }
        .btn-next { background: #6366f1; color: #ffffff; }
        .btn:hover:not(:disabled) { transform: translateY(-2px); filter: brightness(1.1); }
        .auto-save {
            position: fixed; top: 20px; right: 20px; padding: 12px 20px;
            background: #10b981; color: white; border-radius: 8px;
            font-size: 14px; display: none; z-index: 100;
        }
    </style>
</head>
<body>
    <div class="auto-save" id="autoSaveIndicator">✓ Answer saved</div>
    
    <div class="container">
        <div class="progress-container">
            <div class="progress-text" id="progressText">Loading questions...</div>
            <div class="progress-bar"><div class="progress-fill" id="progressFill" style="width: 0%;"></div></div>
        </div>
        
        <div class="question-card">
            <div class="question-number" id="questionNumber">Question</div>
            <div class="question-text" id="questionText">...</div>
            <form id="answerForm">
                <input type="hidden" id="assessmentId" value="${assessmentId}">
                <div class="options" id="optionsContainer"></div>
            </form>
        </div>
        
        <div class="btn-group">
            <button type="button" class="btn btn-prev" id="prevBtn" style="display:none;" onclick="previousQuestion()">← Previous</button>
            <button type="button" class="btn btn-next" id="nextBtn" onclick="nextQuestion()">Next →</button>
        </div>
    </div>
    
    <script>
        let questions = [];
        try {
            // Mengambil data JSON dari Controller
            const rawData = '<%= (request.getAttribute("questionsJson") != null) ? request.getAttribute("questionsJson") : "[]" %>';
            console.log("Raw Data:", rawData);
            questions = JSON.parse(rawData);
        } catch (e) {
            console.error("Gagal parsing data soal:", e);
            questions = [];
        }

        const assessmentId = document.getElementById('assessmentId').value;
        const totalQuestions = questions.length;
        let currentIndex = 0;
        const answers = {};

        // Mulai kuesioner
        if (totalQuestions > 0) {
            loadQuestion(0);
        } else {
            document.getElementById('questionText').textContent = "No questions found in database.";
            document.getElementById('progressText').textContent = "Error";
        }

        function loadQuestion(index) {
            if (index < 0 || index >= totalQuestions) return;
            
            currentIndex = index;
            const q = questions[index];
            
            // Update Teks Pertanyaan
            document.getElementById('questionNumber').textContent = "Question " + (index + 1);
            document.getElementById('questionText').textContent = q.questionText;
            document.getElementById('progressText').textContent = "Question " + (index + 1) + " of " + totalQuestions;
            document.getElementById('progressFill').style.width = ((index + 1) / totalQuestions * 100) + "%";
            
            // Opsi Jawaban (PHQ-9 / GAD-7)
            const options = [
                { v: 0, t: "Not at all" },
                { v: 1, t: "Several days" },
                { v: 2, t: "More than half the days" },
                { v: 3, t: "Nearly every day" }
            ];

            let html = "";
            for (let i = 0; i < options.length; i++) {
                const opt = options[i];
                // Cek apakah sudah pernah dijawab
                const isChecked = (answers[q.id] !== undefined && answers[q.id] === opt.v);
                const checkedAttr = isChecked ? "checked" : "";
                const activeClass = isChecked ? "selected" : "";

                // Render HTML string manual (Tanpa Template Literal)
                html += '<label class="radio-option ' + activeClass + '" onclick="selectOption(this,' + q.id + ',' + opt.v + ')">';
                html += '<input type="radio" name="answer" value="' + opt.v + '" ' + checkedAttr + '>';
                html += '<span class="radio-label">' + opt.t + '</span>';
                html += '</label>';
            }
            
            document.getElementById('optionsContainer').innerHTML = html;
            
            // Tombol Navigasi
            document.getElementById('prevBtn').style.display = index > 0 ? 'block' : 'none';
            document.getElementById('nextBtn').textContent = (index === totalQuestions - 1) ? 'Submit Assessment' : 'Next →';
        }

        // Handle klik opsi jawaban
        function selectOption(element, questionId, val) {
            const allOptions = document.querySelectorAll('.radio-option');
            allOptions.forEach(function(el) {
                el.classList.remove('selected');
            });
            element.classList.add('selected');
            
            const radio = element.querySelector('input[type="radio"]');
            radio.checked = true;
            
            saveAnswer(questionId, val);
        }

        // Auto-save jawaban ke server
        function saveAnswer(questionId, val) {
            answers[questionId] = val;
            
            const body = "assessmentId=" + encodeURIComponent(assessmentId) + 
                         "&questionId=" + encodeURIComponent(questionId) + 
                         "&scaleValue=" + encodeURIComponent(val);

            fetch('${pageContext.request.contextPath}/assessment/save-answer', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: body
            })
            .then(function(res) { return res.json(); })
            .then(function(data) { 
                if(data.success) showIndicator();
            })
            .catch(function(err) { console.error("Save error:", err); });
        }

        function showIndicator() {
            const ind = document.getElementById('autoSaveIndicator');
            ind.style.display = 'block';
            setTimeout(function() { ind.style.display = 'none'; }, 1500);
        }

        // Logic Tombol Next / Submit
        function nextQuestion() {
            const currentQ = questions[currentIndex];
            if (answers[currentQ.id] === undefined) {
                alert("Please select an answer first.");
                return;
            }
            
            if (currentIndex === totalQuestions - 1) {
                if (confirm("Submit assessment now?")) {
                    // FIX: Gunakan FORM POST manual untuk menghindari Error 405
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/assessment/complete';
                    
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'assessmentId';
                    input.value = assessmentId;
                    
                    form.appendChild(input);
                    document.body.appendChild(form);
                    form.submit();
                }
            } else {
                loadQuestion(currentIndex + 1);
            }
        }

        function previousQuestion() {
            if (currentIndex > 0) loadQuestion(currentIndex - 1);
        }
    </script>
</body>
</html>
