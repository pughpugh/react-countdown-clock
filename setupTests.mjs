import { vi } from "vitest";

HTMLCanvasElement.prototype.getContext = () => ({
	clearRect: vi.fn(),
	save: vi.fn(),
	scale: vi.fn(),
	beginPath: vi.fn(),
	arc: vi.fn(),
	closePath: vi.fn(),
	fill: vi.fn(),
	restore: vi.fn(),
	fillText: vi.fn(),
});
