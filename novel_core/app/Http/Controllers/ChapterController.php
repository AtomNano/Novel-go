<?php

namespace App\Http\Controllers;

use App\Models\Chapter;
use App\Models\Novel;
use Illuminate\Http\Request;

class ChapterController extends Controller
{
    // Public: Show Chapter
    public function show($id)
    {
        $chapter = Chapter::find($id);
        if (!$chapter) {
            return response()->json(['message' => 'Chapter not found'], 404);
        }
        return response()->json($chapter);
    }

    // Admin: Create Chapter
    public function store(Request $request, $novelId)
    {
        $this->validate($request, [
            'title' => 'required',
            'content' => 'required',
            'chapter_number' => 'required|integer'
        ]);

        $novel = Novel::find($novelId);
        if (!$novel) {
            return response()->json(['message' => 'Novel not found'], 404);
        }

        $chapter = $novel->chapters()->create($request->all());
        return response()->json($chapter, 201);
    }

    // Admin: Update Chapter
    public function update(Request $request, $id)
    {
        $chapter = Chapter::find($id);
        if (!$chapter) {
            return response()->json(['message' => 'Chapter not found'], 404);
        }

        $chapter->update($request->all());
        return response()->json($chapter);
    }
}
