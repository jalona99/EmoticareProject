<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>${module.id > 0 ? 'Edit' : 'Create'} Module</title>
            <style>
                body {
                    font-family: sans-serif;
                    max-width: 600px;
                    margin: 20px auto;
                }

                .form-group {
                    margin-bottom: 15px;
                }

                label {
                    display: block;
                    margin-bottom: 5px;
                    font-weight: bold;
                }

                input[type="text"],
                textarea {
                    width: 100%;
                    padding: 8px;
                    box-sizing: border-box;
                }

                button {
                    padding: 10px 20px;
                    background-color: #007bff;
                    color: white;
                    border: none;
                    cursor: pointer;
                }
            </style>
        </head>

        <body>
            <h1>${module.id > 0 ? 'Edit' : 'Create'} Module</h1>

            <form action="${pageContext.request.contextPath}/admin/learning/module/save" method="post">
                <input type="hidden" name="id" value="${module.id}" />

                <div class="form-group">
                    <label>Title</label>
                    <input type="text" name="title" value="${module.title}" required />
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <textarea name="description" rows="5" required>${module.description}</textarea>
                </div>

                <div class="form-group">
                    <label>Content URL (Video/PDF Link)</label>
                    <input type="text" name="contentUrl" value="${module.contentUrl}" />
                </div>

                <button type="submit">Save Module</button>
                <a href="${pageContext.request.contextPath}/admin/learning">Cancel</a>
            </form>
        </body>

        </html>