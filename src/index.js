export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (url.pathname === "/" && request.method === "GET") {
      const html = await env.ASSETS.get("index.html");

      if (html === null) {
        return new Response("Frontend not uploaded", {
          status: 404,
        });
      }

      return new Response(html, {
        headers: {
          "Content-Type": "text/html; charset=utf-8",
          "Cache-Control": "public, max-age=60",
        },
      });
    }
  
    if (url.pathname === "/api/messages" && request.method === "GET") {
      const result = await env.DB.prepare(
        `SELECT id, username, message, created_at
         FROM messages
         ORDER BY created_at DESC, id DESC
         LIMIT 10`,
      ).all();

      return Response.json({ messages: result.results });
    }

    if (url.pathname === "/api/messages" && request.method === "POST") {
      let body;

      try {
        body = await request.json();
      } catch {
        return Response.json({ error: "Invalid JSON body" }, { status: 400 });
      }

      if (typeof body.message !== "string" || !body.message.trim()) {
        return Response.json({ error: "Message is required" }, { status: 400 });
      }

      if (body.message.length > 2000) {
        return Response.json(
          { error: "Message must be 2000 characters or fewer" },
          { status: 400 },
        );
      }

      if (
        body.username !== undefined &&
        (typeof body.username !== "string" || body.username.length > 50)
      ) {
        return Response.json(
          { error: "Username must be 50 characters or fewer" },
          { status: 400 },
        );
      }

      const username = body.username?.trim() || null;
      const message = body.message.trim();

      const result = await env.DB.prepare(
        `INSERT INTO messages (username, message)
         VALUES (?, ?)`,
      )
        .bind(username, message)
        .run();

      return Response.json(
        {
          id: result.meta.last_row_id,
          username,
          message,
        },
        { status: 201 },
      );
    }

    if (url.pathname === "/api/messages") {
      return Response.json({ error: "Method not allowed" }, { status: 405 });
    }

    return Response.json({ error: "Not found" }, { status: 404 });
  },
};
