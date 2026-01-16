<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Instructors - EmotiCare Admin</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
            background: #0f172a;
            color: #e5e7eb;
            min-height: 100vh;
            padding: 32px;
        }

        .page-container {
            max-width: 1100px;
            margin: 0 auto;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .back-link {
            font-size: 13px;
            color: #a5b4fc;
            text-decoration: none;
        }

        .back-link:hover { text-decoration: underline; }

        h1 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .subtitle {
            font-size: 14px;
            color: #9ca3af;
            margin-bottom: 24px;
        }

        .card {
            background: #111827;
            border-radius: 16px;
            padding: 20px 24px;
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.5);
            margin-bottom: 24px;
        }

        .card-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 16px;
        }

        .alert {
            padding: 10px 12px;
            border-radius: 10px;
            font-size: 13px;
            margin-bottom: 16px;
        }

        .alert-success { background: rgba(34,197,94,0.15); color: #4ade80; }
        .alert-error { background: rgba(248,113,113,0.15); color: #fca5a5; }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 16px;
        }

        label {
            font-size: 12px;
            color: #9ca3af;
            margin-bottom: 6px;
            display: block;
        }

        input, textarea {
            width: 100%;
            padding: 10px 12px;
            background: #0b1220;
            border: 1px solid #1f2937;
            border-radius: 10px;
            color: #e5e7eb;
            font-size: 13px;
        }

        textarea { min-height: 120px; resize: vertical; }

        .form-actions {
            margin-top: 16px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            border: none;
            padding: 10px 16px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            background: #4f46e5;
            color: white;
            text-decoration: none;
            display: inline-block;
        }

        .btn-secondary {
            background: #334155;
            color: #e2e8f0;
        }

        .btn-secondary:hover { background: #475569; }

        .btn-danger {
            background: #ef4444;
            color: white;
        }

        .btn-danger:hover { background: #dc2626; }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 8px;
            font-size: 14px;
        }

        thead { background: #1f2937; }

        th, td {
            padding: 10px 12px;
            border-bottom: 1px solid #1f2937;
            text-align: left;
            vertical-align: top;
        }

        th {
            font-weight: 600;
            color: #9ca3af;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        tr:nth-child(even) { background: #020617; }
        tr:hover { background: #1f2937; }

        .hint {
            font-size: 12px;
            color: #9ca3af;
            margin-top: 8px;
        }

        .table-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
    </style>
</head>
<body>
<div class="page-container">
    <div class="top-bar">
        <div>Logged in as <strong>${username}</strong></div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">Back to Admin Dashboard</a>
    </div>

    <h1>Manage Instructors</h1>
    <p class="subtitle">Create and maintain instructor profiles for telehealth scheduling.</p>

    <div class="card">
        <div class="card-title">
            <c:choose>
                <c:when test="${isEdit}">Edit Instructor</c:when>
                <c:otherwise>Add New Instructor</c:otherwise>
            </c:choose>
        </div>

        <c:if test="${param.success == 'created'}">
            <div class="alert alert-success">Instructor created successfully.</div>
        </c:if>
        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success">Instructor updated successfully.</div>
        </c:if>
        <c:if test="${param.success == 'deleted'}">
            <div class="alert alert-success">Instructor deleted successfully.</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error">
                <c:choose>
                    <c:when test="${param.error == 'missing_fields'}">Please fill all required fields.</c:when>
                    <c:when test="${param.error == 'profile_create_failed'}">Failed to create instructor.</c:when>
                    <c:when test="${param.error == 'profile_update_failed'}">Failed to update instructor.</c:when>
                    <c:when test="${param.error == 'profile_delete_failed'}">Failed to delete instructor.</c:when>
                    <c:when test="${param.error == 'not_found'}">Instructor not found.</c:when>
                    <c:otherwise>Action failed. Please try again.</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/instructors/${isEdit ? 'update' : 'create'}" method="post">
            <c:if test="${isEdit}">
                <input type="hidden" name="id" value="${editProfile.id}" />
            </c:if>
            <div class="form-grid">
                <div>
                    <label for="name">Name (required)</label>
                    <input id="name" name="name" value="${isEdit ? editProfile.name : ''}" required />
                </div>
                <div>
                    <label for="credentials">Credentials (required)</label>
                    <input id="credentials" name="credentials" value="${isEdit ? editProfile.credentials : ''}" required />
                </div>
                <div>
                    <label for="specialty">Specialty (required)</label>
                    <input id="specialty" name="specialty" value="${isEdit ? editProfile.specialty : ''}" required />
                </div>
                <div style="grid-column: 1 / -1;">
                    <label for="bio">Bio (required)</label>
                    <textarea id="bio" name="bio" required>${isEdit ? editProfile.bio : ''}</textarea>
                </div>
                <div style="grid-column: 1 / -1;">
                    <label for="calendlyInlineCode">Calendly Inline Code (optional)</label>
                    <textarea id="calendlyInlineCode" name="calendlyInlineCode"></textarea>
                    <p class="hint">Paste the inline widget snippet to extract the data-url.</p>
                </div>
                <div style="grid-column: 1 / -1;">
                    <label for="calendlyUrl">Calendly URL (required if inline code is empty)</label>
                    <input id="calendlyUrl" name="calendlyUrl" value="${isEdit ? editProfile.calendlyUrl : ''}" />
                    <p class="hint">Provide either the inline code or the URL. Inline code takes priority.</p>
                </div>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn">${isEdit ? 'Update Instructor' : 'Create Instructor'}</button>
                <c:if test="${isEdit}">
                    <a href="${pageContext.request.contextPath}/admin/instructors" class="btn btn-secondary">Cancel Edit</a>
                </c:if>
            </div>
        </form>
    </div>

    <div class="card">
        <div class="card-title">Existing Instructors</div>
        <table>
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Credentials</th>
                    <th>Specialty</th>
                    <th>Bio</th>
                    <th>Calendly URL</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${professionals}">
                    <tr>
                        <td>${p.name}</td>
                        <td>${p.credentials}</td>
                        <td>${p.specialty}</td>
                        <td>${p.bio}</td>
                        <td>${p.calendlyUrl}</td>
                        <td>
                            <div class="table-actions">
                                <a href="${pageContext.request.contextPath}/admin/instructors/edit/${p.id}" class="btn btn-secondary">Edit</a>
                                <form action="${pageContext.request.contextPath}/admin/instructors/delete" method="post" style="display:inline;">
                                    <input type="hidden" name="id" value="${p.id}" />
                                    <button type="submit" class="btn btn-danger" onclick="return confirm('Delete this instructor?');">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty professionals}">
                    <tr>
                        <td colspan="6" style="text-align:center; color:#9ca3af; padding:16px;">No instructors found.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
