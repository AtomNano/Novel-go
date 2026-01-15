<?php

namespace App\Http\Controllers;

use App\Models\Novel;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class NovelController extends Controller
{
    // Public: List Novels
    public function index()
    {
        return response()->json(Novel::with('chapters')->get());
    }

    // Public: Show Novel
    public function show($id)
    {
        $novel = Novel::with('chapters')->find($id);
        if (!$novel) {
            return response()->json(['message' => 'Novel not found'], 404);
        }
        return response()->json($novel);
    }

    // Admin: Create Novel
    public function store(Request $request)
    {
        // Simple auth check or middleware could handle this
        $this->validate($request, [
            'title' => 'required',
            'description' => 'required'
        ]);

        $novel = Novel::create([
            'title' => $request->title,
            'author' => $request->author,
            'publisher' => $request->publisher,
            'cover' => $request->cover,
            'description' => $request->description,
            'content' => $request->content,
            'published_date' => $request->published_date,
            'admin_id' => Auth::user()->id // Assumes Auth middleware
        ]);

        return response()->json($novel, 201);
    }

    // Admin: Update Novel
    public function update(Request $request, $id)
    {
        $novel = Novel::find($id);
        if (!$novel) {
            return response()->json(['message' => 'Novel not found'], 404);
        }

        $novel->update($request->all());
        return response()->json($novel);
    }

    // Admin: Delete Novel
    public function destroy($id)
    {
        $novel = Novel::find($id);
        if (!$novel) {
            return response()->json(['message' => 'Novel not found'], 404);
        }
        $novel->delete();
        return response()->json(['message' => 'Novel deleted']);
    }
}
