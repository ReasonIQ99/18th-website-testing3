# ReasonIQ99 full source — in-website test viewer edition

## Preview first
Serve this folder with a static server: python -m http.server 8000
Open http://localhost:8000 and click Try a demo test. The five-question demo works without Supabase. Internet is needed for backend library loading; tests/site use system fonts.
Do not rely on double-clicking HTML files: browser file:// restrictions can prevent fetching demo tests.

## Backend setup
1. Create a Supabase Free project. Run supabase-setup.sql ONCE in SQL Editor on a FRESH project. If your older schema is already installed, do not rerun this script: the same tables/functions are compatible; retain your existing setup or migrate carefully with backups.
2. Authentication > Users: add your admin with strong password and confirmed email. Disable public signups if unused.
3. Copy its UUID and run: insert into public.admin_users(user_id) values ('YOUR_USER_UUID');
4. Fill config.js with Supabase project URL and PUBLIC anon/publishable key. NEVER service_role/secret keys.
5. Upload public source files and assets to GitHub Pages. CNAME is reasoniq99.in. Configure custom-domain DNS/HTTPS separately. You can omit SQL and README from deployment.
6. Set Supabase site URL to your website URL. Sign in at admin.html.
7. Test registration -> pending -> approval -> CSV; upload -> preview -> publish -> open test/PDF; publish notification -> view publicly.

## Included
- Supplied logo and founder/contact details; free 999-approved-member offer.
- Admin-only login; public tests with sandboxed inline execution, no forced HTML downloads.
- HTML preview before upload; PDF viewer with new-tab fallback.
- Upload/publish/unpublish/delete resources; publish/unpublish/delete notifications.
- Notifications/resources polled every 30 seconds while page visible (NOT push/WebSocket alerts).
- Duplicate-email prevention; database-level 999 approval cap; CSV formula-prefix protection.
- Self-contained five-question demo with timer, scoring and explanations.

## Test HTML compatibility
Embed all scripts/styles inside the file. Embed images as data URLs. Viewer blocks external scripts, network requests, external fonts, forms, localStorage and same-origin access. Do not add allow-same-origin to the sandbox. Test complex files before publishing; eval()/Function()-dependent libraries may fail. This is not a universal HTML-app hosting environment. Only upload trusted material; sandboxing is not malware scanning. Client-side answer keys are inspectable, not secure for high-stakes exams. Results are shown inside the test, not stored server-side.

## Important limits
Not a deployed or live-tested backend. Setup/testing in your own account is still required. No student login, attempt history, rankings, automatic email/WhatsApp, OTP verification, CAPTCHA or per-IP rate limiting. Public registration RPC can be spammed; add server-verified CAPTCHA and rate limiting (Edge Function) and revoke direct anonymous RPC before broad promotion.
Resources and uploaded bucket are PUBLIC. Unpublish hides listings but does not revoke previously shared file URLs. Delete objects to revoke those links. Early-access/member-only distribution is manual; no protected member library.
Free-provider quotas, inactivity pauses and hosting terms apply; domain renewal is separate. Review GitHub Pages rules if adding commercial offerings. Monitor storage/egress. Keep backups. Legal/privacy copy needs owner review.
UI supports create, publish/unpublish and delete; edit text in Supabase Table Editor or add edit dialogs. Only trusted admins should have access. Account recovery/MFA challenge is not implemented in this UI; use Supabase administration and protect owner accounts.

## Public pre-launch
19 October 2026. Content under preparation. Do not claim all resources are ready. 999 is places, not rupees. No payment gateway.
