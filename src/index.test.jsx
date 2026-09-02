import { act, render } from "@testing-library/react";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import ReactCountdownClock from "./index.jsx";

describe("ReactCountdownClock", () => {
	beforeEach(() => {
		vi.useFakeTimers();
	});

	afterEach(() => {
		vi.useRealTimers();
	});

	it("renders the container and canvases", () => {
		const { container } = render(<ReactCountdownClock seconds={60} />);
		const wrapper = container.querySelector(".react-countdown-clock");
		expect(wrapper).toBeTruthy();

		const canvases = container.querySelectorAll("canvas");
		expect(canvases).toHaveLength(2); // Background and timer
	});

	it("calls onComplete when the timer finishes", () => {
		const onCompleteMock = vi.fn();
		render(<ReactCountdownClock seconds={2} onComplete={onCompleteMock} />);

		act(() => {
			// 200ms initial start delay + 2s countdown + some buffer
			vi.advanceTimersByTime(2500);
		});

		expect(onCompleteMock).toHaveBeenCalledTimes(1);
	});

	it("does not tick when paused", () => {
		const onCompleteMock = vi.fn();
		render(
			<ReactCountdownClock
				seconds={1}
				paused={true}
				onComplete={onCompleteMock}
			/>,
		);

		act(() => {
			vi.advanceTimersByTime(2000);
		});

		expect(onCompleteMock).not.toHaveBeenCalled();
	});

	it("calls onClick when clicked", () => {
		const onClickMock = vi.fn();
		const { container } = render(
			<ReactCountdownClock seconds={10} onClick={onClickMock} />,
		);

		const wrapper = container.querySelector(".react-countdown-clock");
		wrapper.click();

		expect(onClickMock).toHaveBeenCalledTimes(1);
	});
});
