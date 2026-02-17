# Altis Training Mission

## Land navigation route

This mission includes a land navigation helper that shows the next checkpoint grid when a player interacts with a checkpoint object via ACE.

### Usage

Call `rdf_fnc_createRoute` on clients (e.g., from an object init field or a client init script):

- **Start position**: position of the start point (ATL/ASL)
- **Route positions**: array of checkpoint positions
- **Checkpoint objects**: array of objects that act as checkpoints (same order as positions)

Example (object init or client script):

- Start: `startFlag`
- Checkpoints: `cp1`, `cp2`, `cp3`

```
if (hasInterface) then {
    [getPosATL startFlag, [pos1, pos2, pos3], [cp1, cp2, cp3]] call rdf_fnc_createRoute;
};
```

### Notes

- Each checkpoint object gets an ACE action labeled **Get next checkpoint**.
- Interacting shows a 10-digit grid coordinate for the next checkpoint.
- The last checkpoint reports that the route is complete.
