<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${isEdit ? 'Edit' : 'Add'} Question - ${assessmentType.code}</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Inter', sans-serif;
                    background: #1a1d2e;
                    color: #ffffff;
                    padding: 24px;
                }

                .container {
                    max-width: 800px;
                    margin: 0 auto;
                }

                .header {
                    margin-bottom: 32px;
                }

                h1 {
                    font-size: 28px;
                    font-weight: 700;
                    margin-bottom: 8px;
                }

                .card {
                    background: #242838;
                    border-radius: 12px;
                    border: 1px solid #2d3142;
                    padding: 32px;
                }

                .form-group {
                    margin-bottom: 24px;
                }

                label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: 600;
                    color: #9ca3af;
                    font-size: 14px;
                }

                input[type="text"],
                input[type="number"],
                textarea,
                select {
                    width: 100%;
                    padding: 12px;
                    border: 1px solid #2d3142;
                    border-radius: 8px;
                    background: #1a1d2e;
                    color: white;
                    font-family: inherit;
                    font-size: 15px;
                }

                input:focus,
                textarea:focus {
                    outline: none;
                    border-color: #6366f1;
                }

                .checkbox-group {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    cursor: pointer;
                }

                .checkbox-group input {
                    width: 18px;
                    height: 18px;
                    cursor: pointer;
                }

                .btn {
                    padding: 12px 24px;
                    border: none;
                    border-radius: 8px;
                    cursor: pointer;
                    font-weight: 600;
                    font-size: 15px;
                    transition: all 0.2s;
                }

                .btn-primary {
                    background: #6366f1;
                    color: white;
                    width: 100%;
                }

                .btn-primary:hover {
                    background: #4f46e5;
                }

                .btn-secondary {
                    background: #2d3142;
                    color: white;
                    display: block;
                    text-align: center;
                    text-decoration: none;
                    margin-top: 16px;
                }

                .alert {
                    padding: 16px;
                    border-radius: 8px;
                    margin-bottom: 24px;
                    background: rgba(99, 102, 241, 0.1);
                    border: 1px solid #6366f1;
                    color: #a5b4fc;
                    font-size: 14px;
                    line-height: 1.5;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="header">
                    <h1>${isEdit ? 'Edit' : 'Add New'} Question</h1>
                    <p style="color: #9ca3af;">Assessment: ${assessmentType.name}</p>
                </div>

                <div class="card">
                    <c:if test="${!isEdit}">
                        <div class="alert">
                            <strong>Note:</strong> Default scales (choices) for this assessment type will be
                            automatically assigned to this question.
                        </div>
                    </c:if>

                    <form
                        action="${pageContext.request.contextPath}/admin/assessments/questions/${isEdit ? 'edit' : 'add'}"
                        method="post">
                        <input type="hidden" name="id" value="${question.id}">
                        <input type="hidden" name="assessmentTypeId" value="${question.assessmentTypeId}">

                        <div class="form-group">
                            <label>Question Text</label>
                            <textarea name="questionText" rows="3" required
                                placeholder="Enter the question text here...">${question.questionText}</textarea>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label>Question Code (Reference)</label>
                                <input type="text" name="questionCode" value="${question.questionCode}"
                                    placeholder="e.g. GAD7_8" required>
                            </div>
                            <div class="form-group">
                                <label>Display Order</label>
                                <input type="number" name="questionOrder" value="${question.questionOrder}" required
                                    min="1">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="checkbox-group">
                                <input type="checkbox" name="reverseScored" value="true" ${question.reverseScored
                                    ? 'checked' : '' }>
                                <span>Reverse Scored (Check this if higher choices = lower stress/anxiety)</span>
                            </label>
                        </div>

                        <button type="submit" class="btn btn-primary">${isEdit ? 'Update' : 'Create'} Question</button>
                        <a href="${pageContext.request.contextPath}/admin/assessments/questions/type/${assessmentType.id}"
                            class="btn btn-secondary">Cancel</a>
                    </form>
                </div>
            </div>
        </body>

        </html>