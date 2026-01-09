# Content Service (Lumen)

To fully initialize this as a Lumen project, you should run:
`composer install`

If you haven't installed the dependencies yet, the provided `public/index.php` is a standalone mock to demonstrate the endpoints without the full framework payload.

## Endpoints
- GET `/`: Health check
- GET `/novels`: List novels
- GET `/novels/{id}`: Get novel details
